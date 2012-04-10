class AddIndexOnMemberships < ActiveRecord::Migration
  def self.up
    add_index :memberships, [:user_id,:allowed]
  end

  def self.down
    remove_index :memberships, [:user_id,:allowed]
  end
end
