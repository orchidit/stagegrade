class AddNameFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :name, :string
    add_column :users, :username, :string
  end

  def self.down
    remove_column :users, :name
    remove_column :users, :user_name
  end
end
