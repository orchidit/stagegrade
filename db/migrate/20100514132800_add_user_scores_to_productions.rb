class AddUserScoresToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :average_user_score, :float
    add_column :productions, :median_user_score, :float
    add_column :productions, :user_review_updated_at, :datetime
  end

  def self.down
    remove_column :productions, :median_user_score
  end
end
