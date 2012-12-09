class AddConflictFieldsToUserReviews < ActiveRecord::Migration
  def self.up
    add_column :user_reviews, :has_conflict, :boolean, :nullable => true
    add_column :user_reviews, :conflict_details, :string
  end

  def self.down
    remove_column :user_reviews, :conflict_details
    remove_column :user_reviews, :has_conflict
  end
end
