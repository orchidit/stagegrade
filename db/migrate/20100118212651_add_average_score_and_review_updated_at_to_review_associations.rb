class AddAverageScoreAndReviewUpdatedAtToReviewAssociations < ActiveRecord::Migration
  @@tables = [:productions, :critics, :publications]

  def self.up
    @@tables.each do |table|
      add_column table, :review_updated_at, :datetime
      add_column table, :average_score, :float unless table.eql? :productions
      add_column table, :median_score, :float unless table.eql? :productions
    end
  end

  def self.down
    @@tables.each do |table|
      remove_column table, :review_updated_at
      remove_column table, :average_score unless table.eql? :productions
      remove_column table, :median_score unless table.eql? :productions
    end
  end
end
