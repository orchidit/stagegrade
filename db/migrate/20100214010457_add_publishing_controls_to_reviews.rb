class AddPublishingControlsToReviews < ActiveRecord::Migration
    def self.up
      add_column :reviews, :is_published_site, :boolean, :default => false
      add_column :reviews, :is_published_feed, :boolean, :default => false
    end

    def self.down
      remove_column :reviews, :is_published_feed
      remove_column :reviews, :is_published_site
    end
  end