class CreateAdminRoles < ActiveRecord::Migration
  def self.up
    create_table :admin_roles do |t|
      t.integer :id
      t.string :role_name
      t.timestamps
    end
    Admin::Role.create(:role_name => "Super Admin")
    Admin::Role.create(:role_name => "Hospital Admin")
    Admin::Role.create(:role_name => "Normal User")
  end

  def self.down
    drop_table :admin_roles
  end
end
