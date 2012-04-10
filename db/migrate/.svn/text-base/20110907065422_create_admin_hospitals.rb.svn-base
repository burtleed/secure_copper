class CreateAdminHospitals < ActiveRecord::Migration
  def self.up
    create_table :admin_hospitals do |t|
      t.string :name
      t.text :address
      t.integer :user_limit

      t.timestamps
    end

    add_column :users,:hospital_id, :integer
  end

  def self.down
    remove_column :users, :hospital_id
    drop_table :admin_hospitals
  end
end
