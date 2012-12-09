class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :text
      t.integer :user_id
      t.boolean :is_published, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
