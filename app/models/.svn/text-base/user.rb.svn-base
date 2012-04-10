class User < ActiveRecord::Base
  devise :database_authenticatable, :validatable, :trackable, :recoverable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_id, :last_login, :status, 
      :primary_group_id, :user_creation_limit,:hospital_id,:first_name,:last_name,:username,:phone_number,
      :photo, :title_id, :group_ids, :parent_id,:allowed_member_ids,:member_ids,:deny_member_ids,:device_type,:device_registration_id

  belongs_to :role, :class_name => "Admin::Role"
  belongs_to :hospital, :class_name => "Admin::Hospital"
  belongs_to :title, :class_name => "Admin::Title"

  has_one :expire_settings_message, :dependent => :destroy

  has_and_belongs_to_many :groups, :class_name => "Admin::Group"

  has_many :message_recepients,:foreign_key => :recepient_id, :dependent => :destroy
  has_many :messages,:through => :message_recepients, :dependent => :destroy
  has_many :temp_file_uploads, :dependent => :destroy
  has_many :sent_messages,
           :class_name => "Message",
           :foreign_key => 'sender_id',
           :order => "messages.created_at DESC",
           :conditions => ["messages.sender_deleted = ?", false],
           :dependent => :destroy
  has_many :favorites, :dependent => :destroy
  has_many :favorables, :through => :favorites

  has_many :memberships, :foreign_key => "user_id", :dependent => :destroy
  has_many :members, :through => :memberships, :source => :member
  has_many :allowed_members, :through => :memberships, :conditions => "allowed = true", :source => :member
  has_many :deny_members, :through => :memberships, :conditions => "allowed = false", :source => :member

  has_many :inverse_memberships, :class_name => "Membership",:foreign_key => "member_id"
  has_many :inverse_members, :through => :memberships, :source => :user
  has_many :inverse_allowed_members, :through => :memberships, :conditions => "allowed = true", :source => :user
  has_many :inverse_deny_members, :through => :memberships, :conditions => "allowed = false", :source => :user
  
  has_friendly_id :name, :use_slug => true, :approximate_ascii => true, :allow_nil => true

  has_attached_file :photo,
     :styles => {
       :thumb=> "100x100#",
       :mini=> "32x32#",
       :small  => "400x400>" },
     :default => '/images/user_default.png',
     :url => "/system/photos/:id/:style/:basename.:extension",
     :path => ":rails_root/public/system/photos/:id/:style/:basename.:extension"

  ## VALIDATIONS
  validates :first_name, :last_name, :role_id, :hospital_id, :primary_group_id, :title_id, :presence=>true, :unless=>:is_super_admin?
  validates :phone_number,:format => {:with=> /\d{3}-\d{3}-\d{4}/},:unless=>:is_super_admin?
  validates_format_of :email,:with => /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/
  validate :check_user_creation_limit_reached
  
  def check_user_creation_limit_reached
  		if !self.is_super_admin? && self.hospital.user_creation_limit_reached? && self.new_record?
  			self.errors[:base] << "'#{self.hospital.name}\'s' user creation limit is reached. Now you can not add more users."
  		end
  end

  ## SCOPES
  scope :childrens,lambda{|user_id|{:conditions =>["parent_id = ?",user_id]}}
  scope :hospital_users,lambda{|hospital_id|{:conditions =>["hospital_id = ?",hospital_id]}}
  scope :group_users,lambda{|primary_group_id,hospital_id|{:conditions =>["primary_group_id = ? and hospital_id = ?",primary_group_id,hospital_id]}}
  scope :group_user_list, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(role_id != '1' and status = '1')", {:searchname => args.first}]}):{}}
  scope :search_filter, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(first_name like :searchname)", {:searchname => args.first}]}):{}}

  # METHODS
  def self.contact_list(user,except=[])
    if user.is_super_admin?
    	User.all_user(except)	
    elsif user.is_hospital_admin? 
    	User.active_hospital_users(user.hospital_id,except)
    else
    	user.deny_members.each{|u| except << u.id}
    User.grp_users(user.group_ids,user.allowed_members.collect(&:id)).active_users().not_in_ids(except) 
    end
  end
  
  def self.all_user(except=[])
    User.not_in_ids(except)
  end
  
  def self.active_hospital_users(hospital_id,except=[])
		self.hospital_users(hospital_id).active_users().not_in_ids(except)
  end

  def self.active_group_users(hospital_id,group_id,except=[])
		self.group_users(hospital_id,group_id).active_users().not_in_ids(except)
  end
  
  def self.grp_users(group_ids,allowed_ids) 
    if group_ids.any? 
      if allowed_ids.any?
     		scoped(:joins => "left join groups_users on user_id = users.id left join groups on groups.id = groups_users.group_id",:conditions => ["groups.id in (#{group_ids.join(',')}) or users.id in (#{allowed_ids.join(',')})"],:select => "Distinct users.*")
     	else
     		scoped(:joins => "left join groups_users on user_id = users.id left join groups on groups.id = groups_users.group_id",:conditions => ["groups.id in (#{group_ids.join(',')})"],:select => "Distinct users.*")
     	end	
    else
     	if allowed_ids.any?
     		scoped(:conditions => ["or users.id in (#{allowed_ids.join(',')}"])
     	else
     		scoped()
    	end	
    end	 
  end
  
  def self.not_in_ids(id_array)
    if id_array.empty?
    	scoped()
    elsif id_array.size == 1
  	 	scoped(:conditions => ["#{table_name}.id != #{id_array.first}"])
  	else
  	 	scoped(:conditions => ["#{table_name}.id not in (#{id_array.join(',')})"])
  	end		
  end
  
  def self.allowed_users(allowed_ids)
	  if allowed_ids.any?
	  	scoped(:conditions => ["users.id in (#{allowed_ids.join(',')})"])
	  else
	  	scoped()
	  end
  end
  
  def self.active_users
	 scoped(:conditions => ["status = true"])  
  end
  
  def self.get_group_users(hospital_id,grp_ids,except="")
    User.where("hospital_id = #{hospital_id} and users.id not in (SELECT Distinct users.id FROM `users` left join groups_users on user_id = users.id left join groups on groups.id = groups_users.group_id WHERE (groups.id in (#{grp_ids})))").active_users().not_in_ids(except.split(','))
  end 
  
  def self.get_users_for_groups(grp_ids,except="")
    User.joins("left join groups_users on user_id = users.id left join groups on groups.id = groups_users.group_id").where("groups.id in (#{grp_ids})").select("Distinct users.*").active_users().not_in_ids(except.split(','))
  end
  
  def is_hospital_admin?
    (self.role_id == 2)?(true):(false)
  end

  def is_super_admin?
    (self.role_id == 1)?(true):(false)
  end

  def is_any_admin?
    is_hospital_admin? || is_super_admin?
  end
  
  def active?
  	self.status
  end
  
  def inactive?
    !active?
  end
  
  def group_name
  	(!self.primary_user_group.nil?)? self.primary_user_group.name : ""
  end
  
  def title_name
    (self.title.present?)? self.title.name : ""
  end
  
  def role_name
    (!self.role.nil?)? self.role.role_name : ""
  end
 
  def userid
  	self.id
  end
  
  def name
    self.valid_first_name+" "+self.valid_last_name
  end
  
  def valid_first_name
    (self.first_name.blank?)?(""):(self.first_name)
  end

  def valid_last_name
    (self.last_name.blank?)?(""):(self.last_name)
  end
  
  def primary_user_group
    Admin::Group.where(:id=>self.primary_group_id).first
  end
  
  def contact_list(current_user)
    u = []
    if !self.is_any_admin?
    	self.groups.each do |group|
      	group.users.each do |user|
        		u << user unless user.id == current_user.id || user.status == false
      	end
    	end
    elsif self.is_super_admin?
    	User.all.each do |user|
    		u << user unless user.id == current_user.id
    	end
    elsif self.is_hospital_admin?
  		self.hospital.users.each do |user|
  			u << user unless user.id == current_user.id
  		end     
    end
   	self.allowed_members.each do |member|
   	   u << member unless member.id == current_user.id || member.status == false
   	end
    u = u - self.deny_members	
    return u.uniq.sort_by{|user| user[:last_name]}
  end
  
  def all_messages_for_user(contact_user_id)
    m = []
    self.messages.each do |message|
      m << message if message.sender_id == contact_user_id && message.sender_deleted == false && !message.expired_at.present?
    end
    self.sent_messages.each do |message|
      m << message if message.recepient_ids.include?(contact_user_id) 
    end
    return m.uniq.sort_by{|message| message[:created_at]}
  end

  def mini_photo_url
  	"http://#{ActionController::Base.asset_host}#{self.photo.url(:mini)}"
  end

  def has_device_details?
    self.device_registration_id.present? 
  end
  
  def is_android_device?
    (self.device_type.present?)? self.device_type.downcase == "android" : false
  end
  
  def is_iphone_device?
    (self.device_type.present?)? self.device_type.downcase == "iphone" : false
  end

  #Returns a polymorphic array of all user favorites
   def all_favorites
     self.favorites.map{|f| f.favorable }
   end
   
   #Returns trur/false if the provided object is a favorite of the users
   def has_favorite?(favorite_obj)
     favorite = get_favorite(favorite_obj)
     favorite ? self.favorites.exists?(favorite.id) : false
   end
   
   #Sets the object as a favorite of the users
  def has_favorite(favorite_obj)
    favorite = get_favorite(favorite_obj)
    if favorite.nil?
      favorite = Favorite.create(:user_id => self.id,
                          :favorable_type => favorite_obj.class.to_s,
                          :favorable_id => favorite_obj.id)
    end
    favorite
  end
  
  # Removes an object from the users favorites
  def has_no_favorite(favorite_obj)
    favorite = get_favorite(favorite_obj)
  
    # ACA: The original plugin did not properly destroy the favorite.
    # Instead, it just removed the element from the favorites list. If the
    # favorites list was refetched from the DB, surprise! It came back!
  
    if favorite
      self.favorites.delete(favorite)
      favorite_obj.favorites.delete(favorite)
      favorite.destroy
    end
  end
  
  private
  
  # Returns a favorite
  def get_favorite(favorite_obj)
    # ACA: The original plugin did not incoorporate the user id. This
    # meant that the has_many associations did not find favorites
    # properly.
    Favorite.find(:first,
             :conditions => [ 'user_id = ? AND favorable_type = ? AND favorable_id = ?',
                               self.id, favorite_obj.class.to_s, favorite_obj.id ])
  end
  
end
