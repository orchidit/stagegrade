class RelationshipType < ActiveRecord::Base
  has_many :relationships

  validates_presence_of :name
  validates_presence_of :default_connector

  def description
    "#{name} (#{default_connector})"
  end
end
