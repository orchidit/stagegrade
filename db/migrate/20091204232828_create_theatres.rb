class CreateTheatres < ActiveRecord::Migration
  def self.up
    create_table :theatres do |t|
      t.string :name
      t.string :link
      t.string :address
      t.string :phone_number
      t.timestamps
    end
  end

  def self.down
    drop_table :theatres
  end
end
