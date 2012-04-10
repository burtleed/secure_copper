class CreateTableTempAttachments < ActiveRecord::Migration
  def self.up
    create_table :temp_file_uploads do |t|
      t.string :description  
      t.string :data_file_name  
      t.string :data_content_type  
      t.integer :data_file_size  
      t.datetime :data_updated_at
      t.integer :user_id
      t.string :queue_id_flag
      t.string :keyname
      t.timestamps  
    end
    add_index :temp_file_uploads,[:keyname,:user_id]
    add_index :temp_file_uploads,[:queue_id_flag,:user_id]
  end

  def self.down
    drop_table :temp_file_uploads
  end
end
