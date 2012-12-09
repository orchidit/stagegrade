require 'test_helper'

class CriticTest < ActiveSupport::TestCase
  test "validations" do
    c1 = Critic.new
    assert_invalid c1, "Valid without a name"
    
    c1.name = "Test"
    assert c1.valid?, "Invalid when should be valid"

    c1.save!
    c2 = Critic.new(:name => "Test")
    assert_invalid c2, "Valid with non-unique name"
  end
end
