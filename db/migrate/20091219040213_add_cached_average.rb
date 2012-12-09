class AddCachedAverage < ActiveRecord::Migration
  def self.up
    add_column :plays, :average_score, :float
  end

  def self.down
    remove_column :plays, :average_score
  end
end
