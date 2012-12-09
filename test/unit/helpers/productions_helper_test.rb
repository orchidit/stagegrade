require 'test_helper'

class ProductionsHelperTest < ActionView::TestCase
  def test_callout_link
    assert_dom_equal("<a href=\"example.com\" target=\"_blank\"" +
      "<div class=\"buy-tickets-link\">Test</div></a>", callout_link("Test", "example.com"))
  end

  def test_broadway_com_callout_links
    p = Production.new(:broadway_com_id => "test")
    p.save(false)

    p1 = Production.new
    p1.save(false)

    assert_dom_equal("<a href=\"#{p.broadway_hotel_url}\" target=\"_blank\">" +
      "<div class=\"buy-tickets-link\">Hotel Packages</div></a>" +
      "<a href=\"#{p.broadway_ticket_url}\" target=\"_blank\">" +
      "<div class=\"buy-tickets-link\">Best Seats</div></a>", broadway_com_callout_links(p))
    assert_dom_equal("", broadway_com_callout_links(p1))
  end

  def test_ticket_callout_link
    p = Production.new(:ticket_url => "http://example.com")
    p.save(false)

    p1 = Production.new
    p1.save(false)

    assert_dom_equal("<a href=\"#{p.ticket_url}\" target=\"_blank\">" +
      "<div class=\"buy-tickets-link\">Regular Tickets</div></a>", ticket_callout_link(p))
    assert_dom_equal("", ticket_callout_link(p1))
  end

  def test_no_tickets_callout_link
    p = Production.new(:ticket_url => "http://example.com")
    p.save(false)

    p1 = Production.new(:broadway_com_id => "test")
    p1.save(false)

    p2 = Production.new(:ticket_url => "http://example.com", :broadway_com_id => "test")
    p2.save(false)

    p3 = Production.new
    p3.save(false)

    assert_dom_equal("", no_tickets_callout_link(p))
    assert_dom_equal("", no_tickets_callout_link(p1))
    assert_dom_equal("", no_tickets_callout_link(p2))
    assert_dom_equal("<div class=\"buy-tickets-link\">No Tickets Available</div></a>", no_tickets_callout_link(p3))
  end

  def test_ticket_price_range
    p = Production.new
    p.save(false)

    p1 = Production.new(:min_ticket_price => 10)
    p1.save(false)

    p2 = Production.new(:max_ticket_price => 20)
    p2.save(false)

    p3 = Production.new(:min_ticket_price => 10, :max_ticket_price => 20)
    p3.save(false)

    p4 = Production.new(:min_ticket_price => 0, :max_ticket_price => 20)
    p4.save(false)

    assert_equal("Prices Unavailable", ticket_price_range(p))
    assert_equal("$10.00 - ?", ticket_price_range(p1))
    assert_equal("? - $20.00", ticket_price_range(p2))
    assert_equal("$10.00 - $20.00", ticket_price_range(p3))
    assert_equal("? - $20.00", ticket_price_range(p4))
  end
end