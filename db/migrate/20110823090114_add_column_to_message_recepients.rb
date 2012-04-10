class AddColumnToMessageRecepients < ActiveRecord::Migration
  def self.up
    add_column :message_recepients, :read_at, :datetime
    rename_column :message_recepients,:status, :recepient_deleted
  end

  def self.down
    rename_column :message_recepients,:recepient_deleted,:status
    remove_column :message_recepients, :read_at
  end
end
