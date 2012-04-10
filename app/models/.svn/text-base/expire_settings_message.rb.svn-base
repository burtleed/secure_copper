class ExpireSettingsMessage < ActiveRecord::Base
  validates :user_id, :uniqueness => true
  validates :lifespan_hours, :numericality => true, :inclusion => { :in => 1..50, :message => "should be between 1 to 50." }

  def expire_is_set?
  	 (self.flag == "1")? true : false
  end

end