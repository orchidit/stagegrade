class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :user_review_id
      t.boolean :up, :default => nil
      t.timestamps
    end
    
    add_column :user_reviews, :net_votes, :integer, :default => 0, :nullable => false
  end

  def self.down
    remove_column :user_reviews, :net_votes
    drop_table :votes
  end
end
