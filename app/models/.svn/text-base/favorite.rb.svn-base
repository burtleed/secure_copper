class Favorite < ActiveRecord::Base

  #belongs_to :user,:foreign_key => :favorable_id
  #belongs_to :group,:foreign_key => :favorable_id, :class_name => "Admin::Group"
  #belongs_to :favourite_list, :class_name => "User"
  belongs_to :user
  belongs_to :favorable, :polymorphic => true
end
