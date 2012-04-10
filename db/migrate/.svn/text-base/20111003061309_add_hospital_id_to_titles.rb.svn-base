class AddHospitalIdToTitles < ActiveRecord::Migration
  def self.up
    add_column :titles, :hospital_id, :integer
    drop_table :hospital_titles
  end

  def self.down
    remove_column :titles, :hospital_id
  end
end
