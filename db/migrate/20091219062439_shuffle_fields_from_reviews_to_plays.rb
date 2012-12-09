class ShuffleFieldsFromReviewsToPlays < ActiveRecord::Migration
  def self.up
    add_column :plays, :theatre_id, :integer
    add_column :plays, :image_url, :string
    remove_column :reviews, :theatre_id
    remove_column :reviews, :image_url
    rename_column :reviews, :raw_score, :score
  end

  def self.down
    rename_column :reviews, :score, :raw_score
    remove_column :plays, :image_url
    remove_column :plays, :theatre_id
    add_column :reviews, :theatre_id, :integer
    add_column :reviews, :image_url, :string
  end
end
