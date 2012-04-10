class Admin::Title < ActiveRecord::Base
  set_table_name "titles"
  belongs_to :hospital
  has_many :users
  has_friendly_id :name, :use_slug => true,
    :approximate_ascii => true, :allow_nil => true

  validates :name, :hospital_id, :presence =>true

  scope :search_filter, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(name like :searchname)", {:searchname => args.first}]}):{}}


  scope :title_list, lambda { |*args| (args.size > 0 and !args.first.blank?)?({:conditions => ["(hospital_id = :hospital_id)", {:hospital_id => args.first}]}):{}}
end
