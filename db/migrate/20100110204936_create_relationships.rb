class CreateRelationships < ActiveRecord::Migration
  def self.up
    create_table :relationships do |t|
      t.integer :publication_id
      t.integer :play_id
      t.integer :relationship_type_id
      t.string :connector
      t.timestamps
    end
  end

  def self.down
    drop_table :relationships
  end
end
