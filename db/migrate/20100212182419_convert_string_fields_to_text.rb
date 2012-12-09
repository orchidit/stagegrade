class ConvertStringFieldsToText < ActiveRecord::Migration
  def self.up
    change_column :posts, :text, :text
    change_column :productions, :synopsis, :text
    change_column :productions, :editorial_summary, :text
    change_column :quotes, :text, :text
    change_column :reviews, :text, :text
    change_column :reviews, :link_url, :string, :length => 500
    change_column :theatres, :address, :text
    change_column :theatres, :link, :string, :length => 500
  end

  def self.down
    # Not a good idea to undo expansion of field lengths.
    raise ActiveRecord::IrreversibleMigration
  end
end
