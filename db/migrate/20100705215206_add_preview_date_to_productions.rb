class AddPreviewDateToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :preview_date, :date
  end

  def self.down
    remove_column :productions, :preview_date
  end
end
