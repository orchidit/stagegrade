class CreateProductions < ActiveRecord::Migration
  def self.up
    create_table :productions do |t|
      t.boolean :is_on_broadway
      t.boolean :is_musical
      t.boolean :is_for_adults
      t.boolean :is_for_families
      t.boolean :is_for_kids

      t.float :average_score
      t.float :median_score
      
      t.string :ticket_url
      t.string :photo_url
      t.string :photo_credit
      t.string :synopsis
      t.string :editorial_summary
      t.date :opening_date
      t.date :closing_date
      t.integer :running_time
      t.string :running_time_text
      
      t.integer :theatre_id
      t.timestamps
    end
    add_column :reviews, :production_id, :integer
    remove_column :reviews, :play_id
  end

  def self.down
    remove_column :reviews, :production_id
    add_column :reviews, :play_id, :integer
    drop_table :productions
  end
end
