class CreateUserReviews < ActiveRecord::Migration
  def self.up
    create_table :user_reviews do |t|
      t.integer  "posted_by_id"
      t.date     "review_date"
      t.text     "text"
      t.float    "score"
      t.integer  "thumbs"
      t.integer  "production_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :user_reviews
  end
end
