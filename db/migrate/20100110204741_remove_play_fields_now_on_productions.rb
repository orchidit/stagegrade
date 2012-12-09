class RemovePlayFieldsNowOnProductions < ActiveRecord::Migration
  def self.up
    remove_column :plays, :is_on_broadway
    remove_column :plays, :average_score
    remove_column :plays, :theatre_id
    remove_column :plays, :image_url
  end

  def self.down
    add_column :plays, :is_on_broadway, :boolean
    add_column :plays, :average_score, :float
    add_column :plays, :theatre_id, :integer
    add_column :plays, :image_url, :string
  end
end
