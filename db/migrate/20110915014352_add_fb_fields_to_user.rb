class AddFbFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :fb_access_token, :text
    add_column :users, :fb_first_name, :string
    add_column :users, :fb_last_name, :string
    add_column :users, :fb_user_id, :string
    add_column :users, :fb_email, :string
  end

  def self.down
    remove_column :users, :fb_access_token
    remove_column :users, :fb_first_name
    remove_column :users, :fb_last_name
    remove_column :users, :fb_user_id
    remove_column :users, :fb_email
  end
end
