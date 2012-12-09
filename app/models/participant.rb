class Participant < ActiveRecord::Base
  has_many :relationships
  has_many :plays, :through => :relationships, :conditions => "play_id is not null"
  has_many :productions, :through => :relationships, :conditions => "production_id is not null"

  cattr_reader :per_page
  @@per_page = 100

  def person_or_company
    is_person ? "Person" : "Company"
  end
end
