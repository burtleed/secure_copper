class Message < ActiveRecord::Base
  include PushNotification
  attr_accessible :recepient_tokens,:body,:expired_at,:expired,:read_at,:hourlimit,:attachments_attributes,:recepient_ids, :recepient_emails
  attr_accessor :hourlimit
  attr_reader :recepient_tokens,:recepient_emails
  attr_writer :current_step
  
  has_many :message_recepients, :dependent => :destroy
  has_many :recepients, :through => :message_recepients 
  has_many :attachments, :dependent => :destroy
  belongs_to :sender,
             :class_name => "User",
             :foreign_key => 'sender_id'
             

  accepts_nested_attributes_for :attachments,:allow_destroy => true

  validates :body, :sender_id, :recepient_ids,
    :presence=>true

  scope :unread_messages,lambda{|user_id|{:include => [:message_recepients],:joins => :message_recepients,:select => "messages.*",:conditions =>["message_recepients.recepient_id =? and message_recepients.read_at IS NULL and message_recepients.recepient_deleted =? ",user_id,false],:order=> 'messages.created_at desc' }} 
  scope :read_messages,lambda{|user_id|{:include => [:message_recepients],:joins => :message_recepients,:select => "messages.*",:conditions =>["message_recepients.recepient_id =? and message_recepients.read_at IS NOT NULL and message_recepients.recepient_deleted =? ",user_id,false], :order => 'messages.created_at desc'}}
  scope :user_messages,lambda{|user_id|{
  		:conditions => ["message_recepients.recepient_id =? and message_recepients.recepient_deleted = ? and messages.sender_deleted =?",user_id,false,false],
  		:joins => "left join message_recepients on message_id = messages.id",
  		:select => "messages.*,message_recepients.read_at as read_at",
  		:order => "created_at desc"
  		}} 
  		
  scope :all_messages_for_user,lambda{|user_id|{:include => [:message_recepients,:recepients,:sender,:attachments],:joins => :message_recepients,:select => "messages.*",:conditions =>["(messages.sender_id = ?) or (message_recepients.recepient_id = ? and message_recepients.recepient_deleted = false and messages.sender_deleted = false)",user_id,user_id], :order => 'messages.created_at desc'}}
  
  HUMANIZED_ATTRIBUTES = {
		:recepient_ids => "Recepients"
  }
  
  after_create :send_push_notification_to_recepients
  #handle_asynchronously :send_push_notification_to_recepients
  
  def self.messages_between_user(sender_id,recepient_id)
	  Message.joins("left join message_recepients on message_id = messages.id 
	  					  left join users on users.id = message_recepients.recepient_id 
	  					  left join users as sender on sender.id = messages.sender_id
	  					  left join titles on titles.id = users.title_id
	  					  left join titles as sender_titles on sender_titles.id = sender.title_id").
	  					  where("(messages.sender_id = #{sender_id} or messages.sender_id = #{recepient_id}) 
	  					  			and ((message_recepients.recepient_id = #{recepient_id} or message_recepients.recepient_id = #{sender_id}) 
	  					  			and message_recepients.recepient_deleted = false and 
	  					  			messages.sender_deleted = false) and messages.sender_id != message_recepients.recepient_id").
	  					  select("messages.*, message_recepients.recepient_id as recepient_id,
	  					  		    users.email as recepient_email,users.first_name as recepient_first_name,
	  					  		    users.first_name as recepient_last_name,titles.name as recepient_title,message_recepients.read_at as mread_at,
	  					  		    sender.email as sender_email,sender.first_name as sender_first_name,sender.last_name as sender_last_name,sender_titles.name as sender_title").
	  					  order("messages.id asc")		    	  					  		    
  end
  
  def self.human_attribute_name(attr, options={})
	  HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def sender_email
    return self.sender.email
  end
  
  def sender_image_file
    return self.sender.mini_photo_url
  end

  def recepient_tokens=(ids)
    self.recepient_ids = ids.split(",")
  end

  def recepient_emails
    self.recepients.collect(&:email).join(',')
  end
  
  def attachment_urls
    self.attachments.collect(&:photo_url).map{|url| {:url=>url}}
  end

  def self.read(id, reader)
    message = find_by_id(id)
    mesage_rec = message.message_recepients.find_by_recepient_id(reader.id)
    if !mesage_rec.nil?
      mesage_rec.update_attribute("read_at",Time.now) if mesage_rec.read_at.nil?
    end
    message
  end

  # Marks a message as deleted by either the sender or the recipient
  def mark_deleted(user)
  	if self.sender_id == user.id
    	self.sender_deleted = true
    	self.save
    end	 
    if self.message_recepients.collect(&:recepient_id).include?(user.id)
      message_rec = self.message_recepients.find_by_recepient_id(user.id)
      message_rec.update_attribute("recepient_deleted",true)
    end
  end
  
  def formatted_expired_at
  	(self.expired_at.present?)? self.expired_at.strftime("%b %d, %Y %H:%M %p") : self.expired_at
  end
  
  def formatted_created_at
    (self.created_at.present?)? self.created_at.strftime("%b %d, %Y %H:%M %p") : self.created_at
  end
  
  def attachment_present?
  	(self.attachments.size == 0)? false : true
  end
  
  def self.recent_message_list(sender_id)
  	messages = find(:all,:conditions => ["(messages.sender_id = ?  or message_recepients.recepient_id = ?) and (sender_deleted = false and message_recepients.recepient_deleted = false)",sender_id,sender_id],
					 :group => "messages.created_at,sender_id,recepient_id",
					 :joins => :message_recepients,
					 :order => "created_at desc", 
					 :select => "messages.*, message_recepients.recepient_id,message_recepients.read_at, 
					 						 message_recepients.recepient_deleted, count(*) as messages_count"
  	)
  	m = []
  	all_messages = []
  	messages.each do |message|
  		c = [message.sender_id, message.recepient_id]
  		c_reverse = [message.recepient_id, message.sender_id]
  		if(m.include?(c) || m.include?(c_reverse))
				i = m.index(c) if m.index(c).present?
				i = m.index(c_reverse) if m.index(c_reverse).present?
				all_messages[i].messages_count += message.messages_count
  		else
  			m << c
  			all_messages << message
  		end
  	end
    all_messages
  end

end