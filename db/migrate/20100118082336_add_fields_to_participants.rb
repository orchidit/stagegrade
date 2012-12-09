class AddFieldsToParticipants < ActiveRecord::Migration
  def self.up
    remove_column :relationships, :publication_id
    add_column :relationships, :participant_id, :integer
    add_column :relationships, :production_id, :integer
  end

  def self.down
    add_column :relationships, :publication_id
    remove_column :relationships, :participant_id
    remove_column :relationships, :production_id
  end
end
