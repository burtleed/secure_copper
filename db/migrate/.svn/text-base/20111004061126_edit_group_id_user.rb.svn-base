class EditGroupIdUser < ActiveRecord::Migration
  def self.up
    rename_column :users, :group_id, :primary_group_id
  end

  def self.down
    rename_column :users, :primary_group_id, :group_id
  end
end
