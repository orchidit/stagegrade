class AddBylineToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :byline, :text
  end

  def self.down
    remove_column :productions, :byline
  end
end
