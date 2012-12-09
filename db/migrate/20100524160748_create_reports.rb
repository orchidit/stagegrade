class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.string :text
      t.boolean :is_spam, :default => false
      t.integer :user_review_id
      t.integer :posted_by_id
      t.integer :reviewed_by_id
      t.timestamps
    end
  end

  def self.down
    remove_column :table_name, :column_name
    drop_table :reports
  end
end
