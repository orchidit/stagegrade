class AddStarsToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :has_stars, :boolean, :default => false
  end

  def self.down
    remove_column :productions, :has_stars
  end
end
