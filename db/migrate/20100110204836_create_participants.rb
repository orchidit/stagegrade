class CreateParticipants < ActiveRecord::Migration
  def self.up
    create_table :participants do |t|
      t.string :name
      t.boolean :is_person, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :participants
  end
end
