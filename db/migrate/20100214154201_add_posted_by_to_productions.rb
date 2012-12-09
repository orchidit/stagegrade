class AddPostedByToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :posted_by_id, :integer
  end

  def self.down
    remove_column :productions, :posted_by_id
  end
end
