class Theatre < ActiveRecord::Base
  has_many :productions
  has_many :reviews, :through => :productions
  validates_uniqueness_of :name
  validates_presence_of :name
  accepts_duplicate_ids(:simple => true)

  cattr_reader :per_page
  @@per_page = 100

  def address
    self.address("", nil)
  end

  def address(append = "", if_nil = "")
    if self[:address].nil?
      if_nil
    else
      self[:address].gsub(/\n/, "<br />") + append
    end
  end

  def open_productions
    self.productions.select(&:is_playing)
  end

  def closed_productions
    self.productions.reject(&:is_playing)
  end
end