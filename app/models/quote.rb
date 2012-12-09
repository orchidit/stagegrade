class Quote < ActiveRecord::Base
  def html_text
    text.nil? ? nil : text.gsub("\n", "<br />")
  end
  
  def is_active=(new_active)
    logger.info new_active
    Quote.update_all(["is_active=?", false]) if new_active == true or new_active == "1"
    self[:is_active] = (new_active == true or new_active == "1")
  end
end
