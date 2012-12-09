class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_review

  validates_presence_of :user_id
  validates_presence_of :user_review_id
  validate :own_review_voting

  after_save :update_user_review
  after_destroy :update_user_review

  def update_user_review
    user_review.update_vote_counts
    user_review.save(false)
  end

  def own_review_voting
    errors.add_to_base "You can't vote on your own review" if user_review.posted_by_id == self[:user_id]
  end
end
