class AddTitleIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :title_id, :integer
  end

  def self.down
    remove_column :users, :title_id
  end
end
