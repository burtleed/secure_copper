class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :username
      t.string :phone_number
      t.string :photo_file_name  
      t.string :photo_content_type  
      t.integer :photo_file_size  
      t.datetime :photo_updated_at
    end
  end

  def self.down
      remove_column :users, :first_name
      remove_column :users, :last_name
      remove_column :users, :username
      remove_column :users, :phone_number
      remove_column :users, :photo_file_name  
      remove_column :users, :photo_content_type  
      remove_column :users, :photo_file_size  
      remove_column :users, :photo_updated_at
  end
end
