class AddAdControlsToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :is_show_custom_ad, :boolean, :default => false
    add_column :productions, :is_replace_photo, :boolean, :default => true
  end

  def self.down
    remove_column :productions, :is_replace_photo
    remove_column :productions, :is_show_ad
  end
end
