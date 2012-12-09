class CreateReviews < ActiveRecord::Migration
  def self.up
    create_table :reviews do |t|
      t.integer :posted_by_id
      t.integer :play_id
      t.integer :critic_id
      t.integer :publication_id
      t.integer  :theatre_id
      t.date :review_date
      t.string :text
      t.float :raw_score
      t.string :image_url
      t.string :link_url
      t.timestamps
    end
  end

  def self.down
    drop_table :reviews
  end
end
