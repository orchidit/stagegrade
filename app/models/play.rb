class Play < ActiveRecord::Base
  after_save :update_productions

  has_many :productions
  has_many :relationships
  has_many :participants, :through => :relationships
  validates_uniqueness_of :title
  validates_presence_of :title

  cattr_reader :per_page
  @@per_page = 100

  accepts_nested_attributes_for :relationships, :allow_destroy => true

  def title=(new_title)
    self[:title] = new_title
    m = new_title.match(/^((a|an|the)\W)(.*)/i)
    self[:sort_title] = (!m.nil? ? m[3] : new_title)
  end

  def update_productions
    self.productions.reload
    self.productions.each do |prod|
      prod.play_title = self.title
      prod.save(false)
    end
  end
end
