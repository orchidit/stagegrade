class AddCustomAdToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :ad_file_name, :string
    add_column :productions, :ad_content_style, :string
    add_column :productions, :ad_file_size, :integer
    add_column :productions, :ad_updated_at, :datetime
    add_column :productions, :ad_url, :string
  end

  def self.down
    remove_column :productions, :ad_url
    remove_column :productions, :ad_updated_at
    remove_column :productions, :ad_file_size
    remove_column :productions, :ad_content_style
    remove_column :productions, :ad_file_name
  end
end
