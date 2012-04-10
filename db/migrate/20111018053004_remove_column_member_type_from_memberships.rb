class RemoveColumnMemberTypeFromMemberships < ActiveRecord::Migration
  def self.up
  	remove_column :memberships, :member_type
  	add_column :memberships, :allowed,:boolean,:default => true
  end

  def self.down
  	add_column :memberships, :member_type
  	remove_column :memberships, :allowed
  end
end
