class CreatePlays < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.string :title
      t.boolean :is_on_broadway, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :plays
  end
end
