module Reviewed
  def latest_reviews
    self.published_reviews.sort { |x, y|
      (x.review_date || 100.years.ago) <=> (y.review_date || 100.years.ago)
    }
  end

  def average_grade
    Grading.grade_for_score(self.average_score)
  end

  def median_grade
    Grading.grade_for_score(self.median_score)
  end

  def is_published_site
    Review.count(:conditions => ["#{self.class.to_s.downcase}_id=? and is_published_site=?", self.id, true]) > 0
  end
end

module ReviewedClassMethods
  def condition
    "#{self.to_s.downcase}_id is not null"
  end

  def average_grade
    Grading.grade_for_score(Review.published.average(:score, :conditions => condition))
  end

  def median_grade
    Grading.grade_for_score(Grading.median(Review.published.all(:select => "score").map(&:score)))
  end

  def reviews
    Review.all(:conditions => condition)
  end

  def published_reviews
    Review.published.all(:conditions => condition)
  end
end

class ActiveRecord::Base
  @@ordered_by_latest_review_hash = nil
  @@opts = nil

  def self.acts_as_reviewed(options = {})
    extend ReviewedClassMethods
    include Reviewed
  end
end