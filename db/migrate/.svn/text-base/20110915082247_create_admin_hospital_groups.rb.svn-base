class CreateAdminHospitalGroups < ActiveRecord::Migration
  def self.up
    create_table :hospital_groups do |t|
      t.integer :hospital_id
      t.integer :group_id
      t.timestamps
    end
    add_index :hospital_groups,:hospital_id
	  add_index :hospital_groups,:group_id
  end

  def self.down
  end
end
