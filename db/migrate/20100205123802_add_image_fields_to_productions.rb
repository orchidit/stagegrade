class AddImageFieldsToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :photo_file_name, :string
    add_column :productions, :photo_content_style, :string
    add_column :productions, :photo_file_size, :integer
    add_column :productions, :photo_updated_at, :datetime
    remove_column :productions, :photo_url
  end

  def self.down
    add_column :productions, :photo_url, :string
    remove_column :productions, :photo_updated_at
    remove_column :productions, :photo_file_size
    remove_column :productions, :photo_content_style
    remove_column :productions, :photo_file_name
  end
end
