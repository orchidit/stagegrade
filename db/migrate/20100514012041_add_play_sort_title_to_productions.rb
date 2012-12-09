class AddPlaySortTitleToProductions < ActiveRecord::Migration
    def self.up
      add_column :productions, :play_sort_title, :string
      Production.reset_column_information
      Play.all.each { |p| p.title = p.title; p.save(false) }
    end

    def self.down
      remove_column :productions, :play_sort_title
    end
  end