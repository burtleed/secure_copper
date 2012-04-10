class CreateTableExpireSettings < ActiveRecord::Migration
  def self.up
      create_table :expire_settings_messages do |t|
        t.integer :user_id
        t.string :flag,:limit => 1, :default => false
        t.integer :lifespan_hours,:default => 0
        t.timestamps
      end
  end

  def self.down
      drop_table :expire_settings_messages
  end
end
