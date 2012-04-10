class AddHospitalIdToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :hospital_id, :integer
    drop_table :hospital_groups
  end

  def self.down
    remove_column :groups, :hospital_id
  end
end
