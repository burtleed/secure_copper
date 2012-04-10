class AddColumnGroupIdToUsers_ < ActiveRecord::Migration
  def self.up
    add_column :users, :group_id, :integer
    add_column :users, :user_creation_limit, :integer,:default => 0
  end

  def self.down
    remove_column :users, :group_id
    remove_column :users, :user_creation_limit
  end
end
