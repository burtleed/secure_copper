class AddIndexesOnAllTables < ActiveRecord::Migration
  def self.up
    add_index :users,:first_name
    add_index :users,:role_id
    add_index :users,:title_id
    add_index :users,:primary_group_id
    add_index :users,:hospital_id
    add_index :users,:status
    
    add_index :messages, :sender_id
    
    add_index :expire_settings_messages, :user_id
    
    add_index :attachments, :message_id
    
    add_index :groups_users, [:user_id,:group_id]
  end

  def self.down
    remove_index :users,:first_name
    remove_index :users,:role_id
    remove_index :users,:title_id
    remove_index :users,:primary_group_id
    remove_index :users,:hospital_id
    remove_index :users,:status
    
    remove_index :messages, :sender_id
    
    remove_index :expire_settings_messages, :user_id
    
    remove_index :attachments, :message_id
    
    remove_index :groups_users, [:user_id,:group_id]
  end
end

