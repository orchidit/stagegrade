require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "name" do
    u = User.new

    # Nil First
    u.first_name = nil
    u.last_name = nil
    assert_equal u.name, "", "User name with nil first/nil last does not match empty string"

    u.first_name = nil
    u.last_name = ""
    assert_equal u.name, "", "User name with nil first/last does not match empty string"

    u.first_name = nil
    u.last_name = "Last"
    assert_equal u.name, "Last", "User name with nil first/non-empty last does not match last name"

    # Blank First Name
    u.first_name = ""
    u.last_name = nil
    assert_equal u.name, "", "User name with blank first/nil last does not match empty string"

    u.first_name = ""
    u.last_name = ""
    assert_equal u.name, "", "User name with blank first/last does not match empty string"

    u.first_name = ""
    u.last_name = "Last"
    assert_equal u.name, "Last", "User name with blank first/non-empty last does not match last name"

    # Non-Empty First
    u.first_name = "First"
    u.last_name = nil
    assert_equal u.name, "First", "User name with first/empty last does not match first name"

    u.first_name = "First"
    u.last_name = ""
    assert_equal u.name, "First", "User name with first/empty last does not match empty string"

    u.first_name = "First"
    u.last_name = "Last"
    assert_equal u.name, "First Last", "User name with first/last does not match format"
  end

  test "name_with_title" do
    u = User.new

    # Nil Name
    u.first_name = nil
    u.title = nil
    assert_equal u.name_with_title, "", "User with nil name/nil title is not empty string"

    u.first_name = nil
    u.title = ""
    assert_equal u.name_with_title, "", "User with nil name/empty title is not empty string"

    u.first_name = nil
    u.title = "Title"
    assert_equal u.name_with_title, "Title", "User with nil name/non-empty title is not title"

    # Empty Name
    u.first_name = ""
    u.title = nil
    assert_equal u.name_with_title, "", "User with empty name/nil title is not empty string"

    u.first_name = ""
    u.title = ""
    assert_equal u.name_with_title, "", "User with empty name/empty title is not empty string"

    u.first_name = ""
    u.title = "Title"
    assert_equal u.name_with_title, "Title", "User with empty name/non-empty title is not title"

    # Non-Empty Name
    u.first_name = "First"
    u.title = nil
    assert_equal u.name_with_title, "First", "User with name/nil title does not match format"

    u.first_name = "First"
    u.title = ""
    assert_equal u.name_with_title, "First", "User with name/empty title does not match format"

    u.first_name = "First"
    u.title = "Title"
    assert_equal u.name_with_title, "First, Title", "User with empty name/non-empty title does not match format"
  end
  
  test "admin?" do
    non_admin = Role.new(:name => "user"); non_admin.save!
    admin = Role.new(:name => "admin"); admin.save!

    u = User.new
    u.email = "a@a.com"
    u.single_access_token = "123abc"
    u.password = "password"
    u.save(false)

    u.role = admin
    assert_equal u.admin?, true, "Admin role should be an admin"

    u.role = non_admin
    assert_equal u.admin?, false, "Non-Admin role should not be an admin"

    u.role = nil
    assert_equal u.admin?, false, "Nil role should not be an admin"
  end
end