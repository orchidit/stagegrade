class AddTeaserToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :teaser, :string
  end

  def self.down
    remove_column :productions, :teaser
  end
end
