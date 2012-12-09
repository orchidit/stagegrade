class AddPublishDatesToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :site_published_at, :datetime
    add_column :productions, :feed_published_at, :datetime
  end

  def self.down
    remove_column :productions, :feed_published_at
    remove_column :productions, :site_published_at
  end
end
