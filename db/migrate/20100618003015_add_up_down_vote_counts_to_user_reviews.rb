class AddUpDownVoteCountsToUserReviews < ActiveRecord::Migration
  def self.up
    add_column :user_reviews, :up_vote_count, :integer, :default => 0, :nullable => false
    add_column :user_reviews, :down_vote_count, :integer, :default => 0, :nullable => false
    remove_column :user_reviews, :net_votes
    UserReview.reset_column_information
    UserReview.all.each do |ur|
      ur.update_vote_counts
      ur.save(false)
    end
  end

  def self.down
    add_column :user_reviews, :net_votes, :integer, :default => 0, :nullable => false
    remove_column :user_reviews, :up_vote_count
    remove_column :user_reviews, :down_vote_count
  end
end
