class Admin::Group < ActiveRecord::Base
  set_table_name "groups"
  has_and_belongs_to_many :users
 ## has_many :favorites,:foreign_key => :favorable_id, :class_name => "Favorite"
 ## has_many :favourite_lists, :through =>  :favorites, :source => :user
  has_many :favorites, :as => :favorable
  has_many :favoriting_users, :through => :favorites, :source => :user
  attr_reader :add_users_ids,:remove_users_ids
  
  belongs_to :hospital
  
  has_friendly_id :name, :use_slug => true,
    :approximate_ascii => true, :allow_nil => true

  scope :search_filter, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(name like :searchname)", {:searchname => args.first}]}):{}} 

  scope :group_list, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(hospital_id = :hospital_id)", {:hospital_id => args.first}]}):{}}

  validates :name, :hospital_id, :presence=>true

  def add_users_ids=(ids)
  	  #self.user_ids = self.user_ids + ids.split(',') if ids.any?
  	  self.user_ids = ids.split(',').map{|p| p.to_i} 
  end

  def remove_users_ids=(ids)
  	  self.user_ids = self.user_ids - ids.split(',').map{|p| p.to_i} if ids.any?
  end

  def accepts_favorite?( user_obj )
	  user_obj.has_favorite?( self )
  end
	
  def accepts_favorite( user_obj )
	  user_obj.has_favorite( self )
  end
	
  def accepts_no_favorite( user_obj )
	  user_obj.has_no_favorite( self )
  end
  
end
