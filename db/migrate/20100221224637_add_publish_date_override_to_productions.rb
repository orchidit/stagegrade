class AddPublishDateOverrideToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :is_site_published_at_override, :boolean, :default => false
    add_column :productions, :is_feed_published_at_override, :boolean, :default => false
    add_column :productions, :site_published_at_override, :datetime
    add_column :productions, :feed_published_at_override, :datetime
  end

  def self.down
    remove_column :productions, :feed_published_at_override
    remove_column :productions, :site_published_at_override
    remove_column :productions, :is_site_published_at_override
    remove_column :productions, :is_feed_published_at_override
  end
end
