class Post < ActiveRecord::Base
  include TextHelper
  include ActionView::Helpers::UrlHelper

  belongs_to :user
  validates_numericality_of :cutoff_length, :allow_nil => true, :only_integer => true, :greater_than_or_equal_to => 0

  named_scope :published, :conditions => { :is_published => true }

  def initialize(attributes = nil)
    super(attributes)
  end

  def is_published=(publish)
    if self.is_published_before_type_cast != publish
      self[:is_published] = publish
      self[:published_at] = (publish ? Time.now : nil)
    end
  end

  def original_published_at
    self[:published_at]
  end

  def published_at
    if self.is_published and self.is_published_at_override and !self.published_at_override.nil?
      self.published_at_override
    else
      self[:published_at]
    end
  end

  def has_cutoff?
    !cutoff_length.nil? and cutoff_length > 0
  end
end
