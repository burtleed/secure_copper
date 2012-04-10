class AddResetPasswordTokenToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :reset_password_token, :string
  end

  def self.down
    remove_column :users, :reset_password_token
  end
end
