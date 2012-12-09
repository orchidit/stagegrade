class Publication < ActiveRecord::Base
  has_many :reviews
  has_many :critics, :through => :reviews, :uniq => true
  has_many :published_reviews, :class_name => "Review", :conditions => ["is_published_site=?", true]
  has_many :published_critics, :class_name => "Critic", :through => :published_reviews, :uniq => true

  validates_uniqueness_of :name
  validates_presence_of :name
  acts_as_reviewed
  accepts_duplicate_ids(:simple => true)

  cattr_reader :per_page
  @@per_page = 100

end
