class AddDeviceTypeAndDeviceRegistrationIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :device_type, :string
    add_column :users, :device_registration_id, :string, :limit => 2000
  end

  def self.down
    remove_column :users, :device_registration_id
    remove_column :users, :device_type
  end
end
