module ProductionsHelper
  def callout_link(text, url)
    "<a href=\"#{url}\" target=\"_blank\"><div class=\"buy-tickets-link\">#{text}</div></a>"
  end

  def broadway_com_callout_links(prod)
    if !prod.broadway_com_id.empty?
      callout_link("Hotel Packages", prod.broadway_hotel_url) +
      callout_link("Best Seats", prod.broadway_ticket_url)
    else
      ""
    end
  end

  def ticket_callout_link(prod)
    if !prod.ticket_url.empty?
      callout_link "Regular Tickets", prod.ticket_url
    else
      ""
    end
  end

  def no_tickets_callout_link(prod)
    if prod.broadway_com_id.empty? and prod.ticket_url.empty?
      "<div class=\"buy-tickets-link\" style=\"color:gray\">No Tickets Available</div>"
    else
      ""
    end
  end

  def ticket_price_range(prod)
    if (prod.min_ticket_price.nil? and prod.max_ticket_price.nil?) or
        (prod.min_ticket_price == 0 and prod.max_ticket_price == 0)
      "Prices Unavailable"
    else
      (prod.min_ticket_price != 0 ? number_to_currency(prod.min_ticket_price) || "?" : "?") + " - " +
      (prod.max_ticket_price != 0 ? number_to_currency(prod.max_ticket_price) || "?" : "?")
    end
  end
end