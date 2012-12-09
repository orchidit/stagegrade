class AddSourceToEmails < ActiveRecord::Migration
  def self.up
    add_column :emails, :source, :string
  end

  def self.down
    remove_column :emails, :source
  end
end
