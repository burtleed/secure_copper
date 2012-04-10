class CreateHospitalTitles < ActiveRecord::Migration
  def self.up
    create_table :hospital_titles do |t|
      t.integer :hospital_id
      t.integer :title_id
      t.timestamps
    end
      add_index :hospital_titles,:hospital_id
	   add_index :hospital_titles,:title_id
  end

  def self.down
  end
end
