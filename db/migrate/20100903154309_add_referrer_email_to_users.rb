class AddReferrerEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referrer_email, :string
  end

  def self.down
    remove_column :users, :referrer_email
  end
end
