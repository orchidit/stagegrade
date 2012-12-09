class ProductionPanel < ImagePanel
  def has_item_label_method?; true; end
  def has_item_detail_label_method?; true; end
  def has_item_url_method?; true; end
  def has_item_accessory_method?; true; end

  def render_accessory?
    true
  end

  def item_label_method(item)
    item.play_title
  end

  def item_detail_label_method(item)
    if self[:item_detail_label_method] == ":median_user_grade"
      item.median_user_grade
    else
      item.median_grade
    end
  end

  def item_url_method(item)
    item
  end

  def item_accessory_method(item)
    item.grade_buy_buttons
  end

  def accessory_render_type(item)
    :partial
  end

  def accessory_render_name(item)
    "productions/grade_buy_buttons"
  end

  def accessory_locals(item)
    { :production => item }
  end
end
