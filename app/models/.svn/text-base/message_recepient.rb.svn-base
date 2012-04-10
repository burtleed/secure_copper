class MessageRecepient < ActiveRecord::Base
attr_accessible :message_id, :recepient_id
  belongs_to :message
  belongs_to :recepient, :class_name => "User"

  def read?
    self.read_at.nil? ? false : true
  end
  
  def recepient_email 
  	 self.recepient.email
  end
end