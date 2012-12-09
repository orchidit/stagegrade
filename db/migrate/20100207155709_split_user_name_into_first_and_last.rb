class SplitUserNameIntoFirstAndLast < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.reset_column_information
    User.all.each do |u|
      array = u.name.split(" ")
      
      if array.length == 2
        u.first_name = array[0]
        u.last_name = array[1]
      end
      u.save!
    end
    remove_column :users, :name
  end

  def self.down
    add_column :users, :name, :string
    
    User.reset_column_information
    User.all.each do |u|
      u.name = [u.first_name, u.last_name].join(" ").strip
      u.save!
    end
    
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
