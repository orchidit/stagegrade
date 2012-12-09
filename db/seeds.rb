# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

admin = Role.find_or_create_by_name("admin")
admin.save!
user = Role.find_or_create_by_name("user")
user.save!
su = Role.find_or_create_by_name("super_user")
su.save!

admin_defaults = { :password => "fka_criticometer", :password_confirmation => "fka_criticometer", :role => admin}
admins = ["martin", "doug", "jon", "rob", "isaac"]

admins.each do |a|
  u = User.find_or_create_by_name(a)
  if u.new_record?
    u.update_attributes(admin_defaults)
    u.save(false)
  end
end