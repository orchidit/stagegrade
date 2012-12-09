class AddImagePanelFields < ActiveRecord::Migration
  def self.up
    add_column :panels, :image_file_name, :string
    add_column :panels, :unattached_image_url, :string
    add_column :panels, :image_link, :text
  end

  def self.down
    remove_column :panels, :image_link
    remove_column :panels, :unattached_image_url
    remove_column :panels, :image_file_name
  end
end
