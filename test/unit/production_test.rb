require 'test_helper'

class ProductionTest < ActiveSupport::TestCase
  def test_set_play_title
    p = Production.new
    p.play_title = "title"
    assert p.save, "Couldn't save new production/new play"

    p.play_title = "title2"
    assert p.save, "Couldn't save existing production/new play"

    p.play_title = "title3"
    assert p.save, "Couldn't save existing production/existing play"

    p2 = Production.new
    p2.play_title = "title"
    assert p2.save, "Couldn't save new production/existing play"
  end

  def test_opening_date_in_future
    "If the opening date is in the future, text reads 'Opens <date>'."
    p = Production.new
    p.opening_date = 10.days.from_now
    assert_equal p.opening_date_text, "Opens #{p.opening_date.strftime('%x')}"
  end

  def test_opening_date_in_the_past
    "If the opening date is in the past, text reads 'Opened <date>'."
    p = Production.new
    p.opening_date = 10.days.ago
    assert_equal p.opening_date_text, "Opened #{p.opening_date.strftime('%x')}"
  end

  def test_opening_date_not_specified_and_show_open
    "If the opening date is not specified and show is Open (either override is set to Open or closing date in the future), text reads 'Opened'."
    p = Production.new
    p.is_playing_override = "Open"
    assert_equal p.opening_date_text, "Opened"

    p.is_playing_override = nil
    p.closing_date = 10.days.from_now
    assert_equal p.opening_date_text, "Opened"
  end

  def test_opening_date_not_specified_and_show_closed_with_past_date
    "If the opening date is not specified and show is Closed (by setting closing date in the past), text reads 'Opened'."
    p = Production.new
    p.closing_date = 10.days.ago
    assert_equal p.opening_date_text, "Opened"
  end

  def test_opening_date_not_specified_and_show_closed_without_past_date
    "If the opening date is not specified and show is Closed (override is set to Closed or closing date is not specified), text reads 'Unknown Opening Date'."
    assert_proc = Proc.new { |p| assert_equal p.opening_date_text, "Unknown Opening Date" }

    p = Production.new
    assert_proc.call(p)

    p.is_playing_override = "Closed"
    assert_proc.call(p)
  end

  def test_closing_date_in_future
    "If the closing date is in the future, text reads 'Closes <date>'."
    p = Production.new
    p.closing_date = 10.days.from_now
    assert_equal p.closing_date_text, "Closes #{p.closing_date.strftime('%x')}"
  end

  def text_closing_date_in_past
    "If the closing date is in the past, text reads 'Closed <date>'."
    p = Production.new
    p.closing_date = 10.days.ago
    assert_equal p.closing_date_text, "Closed #{p.closing_date.strftime('%x')}"
  end

  def test_closing_date_not_specified_and_show_open
    "If the closing date is not specified and show is Open (either override is set to Open or opening date in past), text reads 'Open Run'."
    assert_proc = Proc.new { |p| assert_equal p.closing_date_text, "Open Run" }
    p = Production.new
    p.is_playing_override = "Open"
    assert_proc.call(p)

    p.is_playing_override = nil
    p.opening_date = 10.days.ago
    assert_proc.call(p)
  end

  def test_closing_date_not_specified_and_show_closed
    "If the closing date is not specified and show is not Open (override is set to Closed), text reads 'Closed'."
    p = Production.new
    p.is_playing_override = "Closed"
    assert_equal p.closing_date_text, "Closed"
  end

  def test_overrides_specified
    p = Production.new
    p.is_playing_override = "Open"
    assert p.is_playing

    p.is_playing_override = "Closed"
    assert !p.is_playing
  end

  def test_override_not_specified_and_opening_and_closing_specified
    "If override not specified and... (cases where both opening and closing are specified)"
    future = 10.days.from_now
    past = 10.days.ago

    p = Production.new
    # opening is in the past and closing is in the future, show is Open. (Opened <date> / Closing <date>)
    p.opening_date = past
    p.closing_date = future
    assert_equal p.is_playing, true
    assert_equal p.opening_date_text, "Opened #{p.opening_date.strftime('%x')}"
    assert_equal p.closing_date_text, "Closes #{p.closing_date.strftime('%x')}"

    # opening is in the future and closing is in the future, show is Closed. (Opens <date> / Closing <date>)
    p.opening_date = future
    p.closing_date = future
    assert_equal p.is_playing, false
    assert_equal p.opening_date_text, "Opens #{p.opening_date.strftime('%x')}"
    assert_equal p.closing_date_text, "Closes #{p.closing_date.strftime('%x')}"

    # opening is in the past and closing is in the past, show is Closed. (Opened <date> / Closed <date>)
    p.opening_date = past
    p.closing_date = past
    assert_equal p.is_playing, false
    assert_equal p.opening_date_text, "Opened #{p.opening_date.strftime('%x')}"
    assert_equal p.closing_date_text, "Closed #{p.closing_date.strftime('%x')}"

    # opening is in the future and closing is in the past, ... (this is an invalid setting, but listed here for completeness - validation should be added to not allow this case).
    p.opening_date = future
    p.closing_date = past

    play = Play.new; play.title = "Test"; play.save!
    p.play_id = play.id
    assert_invalid p
  end

  def test_override_not_specified_and_opening_or_closing_or_both_unspecified
    "If override not specified and... (these are cases where opening or closing or both are unspecified)"
    future = 10.days.from_now
    past = 10.days.ago

    p = Production.new
    # both opening and closing dates are unspecified, show is Closed. (Unknown Opening Date / Closed)
    assert !p.is_playing
    assert_equal p.opening_date_text, "Unknown Opening Date"
    assert_equal p.closing_date_text, "Closed"

    # opening is in the past and closing date is unspecified, show is Open. (Opened <date> / Open Run)
    p.opening_date = past
    assert p.is_playing
    assert_equal p.opening_date_text, "Opened #{p.opening_date.strftime('%x')}"
    assert_equal p.closing_date_text, "Open Run"

    # opening is unspecified and closing is in the future, show is Open. (Opened / Closes <date>)
    p.opening_date = nil
    p.closing_date = future
    assert p.is_playing
    assert_equal p.opening_date_text, "Opened"
    assert_equal p.closing_date_text, "Closes #{p.closing_date.strftime('%x')}"

    # opening is unspecified and closing is in the past, show is Closed. (Opened / Closed <date>)
    p.opening_date = nil
    p.closing_date = past
    assert !p.is_playing
    assert_equal p.opening_date_text, "Opened"
    assert_equal p.closing_date_text, "Closed #{p.closing_date.strftime('%x')}"

    # opening is in the future and closing date is unspecified, show is Closed. (Opens <date> / Open Run)
    p.opening_date = future
    p.closing_date = nil
    assert !p.is_playing
    assert_equal p.opening_date_text, "Opens #{p.opening_date.strftime('%x')}"
    assert_equal p.closing_date_text, "Open Run"
  end
end
