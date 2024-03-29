class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.string :address
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end
