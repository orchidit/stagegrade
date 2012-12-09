class AddFieldsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :is_published_at_override, :boolean, :default => false
    add_column :posts, :published_at_override, :datetime
    add_column :posts, :cutoff_length, :integer, :default => 300
    Post.reset_column_information
    Post.all { |p| p.cutoff_length == 300; p.save(false) }
  end

  def self.down
    remove_column :posts, :cutoff_length
    remove_column :posts, :published_at_override
    remove_column :posts, :is_published_at_override
  end
end
