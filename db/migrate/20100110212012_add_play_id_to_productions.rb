class AddPlayIdToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :play_id, :integer
  end

  def self.down
    remove_column :productions, :play_id
  end
end
