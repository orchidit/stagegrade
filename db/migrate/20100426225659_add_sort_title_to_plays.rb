class AddSortTitleToPlays < ActiveRecord::Migration
  def self.up
    add_column :plays, :sort_title, :string
    Play.reset_column_information
    Play.all.each { |p| p.title = p.title; p.save(false) }
  end

  def self.down
    remove_column :plays, :sort_title
  end
end
