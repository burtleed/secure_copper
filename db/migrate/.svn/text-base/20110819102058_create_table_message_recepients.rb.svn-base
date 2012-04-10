class CreateTableMessageRecepients < ActiveRecord::Migration
  def self.up
    create_table :message_recepients do |t|
      t.integer :message_id
      t.integer :recepient_id
      t.boolean :status, :default => 0
    end
    add_index :message_recepients, [:message_id,:recepient_id]
  end

  def self.down
    drop_table :message_recepients
  end
end
