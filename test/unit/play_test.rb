require 'test_helper'

class PlayTest < ActiveSupport::TestCase
  def test_update_productions
    p = Play.new(:title => "title")
    assert p.save, "Couldn't save new play"

    prod = Production.new
    # TODO: Setting play directly will cause the test to fail since it won't trigger
    # the play's after_save callback which updates the production's play_title.
    prod.play_title = p.title
    prod.save

    p.title = "title2"
    assert p.save, "Couldn't save existing play"

    prod.reload
    assert_equal prod.play_title, "title2"
    assert_equal prod.play, p
  end

  def test_validations
    p1 = Play.new
    assert_invalid p1, "Valid without a title"

    p1.title = "Test"
    assert p1.valid?, "Invalid when should be valid"

    p1.save!
    p2 = Play.new(:title => "Test")
    assert_invalid p2, "Valid with non-unique title"
  end
end