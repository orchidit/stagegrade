class AddIsPlayingOverrideToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :is_playing_override, :string
  end

  def self.down
    remove_column :productions, :is_playing_override
  end
end
