class Admin::Hospital < ActiveRecord::Base

  has_friendly_id :name, :use_slug => true,
    :approximate_ascii => true, :allow_nil => true

  has_many :users
  has_many :groups
  has_many :titles  
  
  validates :name, :presence =>true
  validates :user_limit, :presence =>true,:numericality =>true

  scope :search_filter, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(name like :searchname)", {:searchname => args.first}]}):{}}
  
  def user_creation_limit_reached?
 	 User.hospital_users(self.id).active_users.size > self.user_limit
  end 
end