class RemoveColumnFromMessages < ActiveRecord::Migration
  def self.up
    remove_column :messages, :recipient_id
    remove_column :messages, :recipient_deleted
    remove_column :messages, :read_at
  end

  def self.down
    add_column :messages, :recipient_id, :integer
    add_column :messages, :recipient_deleted, :boolean
    add_column :messages, :read_at, :datetime
  end
end
