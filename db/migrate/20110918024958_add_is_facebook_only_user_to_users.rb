class AddIsFacebookOnlyUserToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :is_facebook_only, :boolean
  end

  def self.down
    remove_column :users, :is_facebook_only
  end
end
