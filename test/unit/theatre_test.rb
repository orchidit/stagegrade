require 'test_helper'

class TheatreTest < ActiveSupport::TestCase
  test "validations" do
    c1 = Theatre.new
    assert_invalid c1, "Valid without a name"
    
    c1.name = "Test"
    assert c1.valid?, "Invalid when should be valid"

    c1.save!
    c2 = Theatre.new(:name => "Test")
    assert_invalid c2, "Valid with non-unique name"
  end
end
