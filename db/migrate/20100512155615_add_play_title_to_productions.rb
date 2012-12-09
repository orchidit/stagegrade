class AddPlayTitleToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :play_title, :string
    Production.reset_column_information
    Production.all.each { |p|
      if !p.play.nil?
        p.play_title = p.play.title; p.save(false)
      end
    }
  end

  def self.down
    remove_column :productions, :play_title
  end
end
