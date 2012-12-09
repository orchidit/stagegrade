class Panel < ActiveRecord::Base
  named_scope :in_order, :order => "order_seq"

  validates_uniqueness_of :order_seq
  before_validation_on_create :set_order_seq

  def set_order_seq
    self[:order_seq] = (Panel.maximum(:order_seq) || -1) + 1
  end

  def move(direction)
    mod = (direction == :up ? -1 : 1)
    @target_panel = Panel.first(:conditions => ["order_seq = ?", self.order_seq + mod])

    if !@target_panel.nil?
      self.order_seq = self.order_seq + mod
      save(false)
      @target_panel.order_seq = @target_panel.order_seq - mod
      @target_panel.save(false)
    end
  end

  def method_missing(method, *args)
    match = method.to_s.match(/^has_(.*_method)\?$/)
    if match.nil?
      super
    else
      !self[match[1].to_sym].nil? and !self[match[1].to_sym].empty?
    end
  end

  def render_accessory?
    false
  end

  def item_label_method(item)
    do_method_with_item(:item_label_method, item)
  end

  def item_detail_label_method(item)
    do_method_with_item(:item_detail_label_method, item)
  end

  def item_url_method(item)
    do_method_with_item(:item_url_method, item)
  end

  def item_accessory_method(item)
    do_method_with_item(:item_accessory_method, item)
  end
  
  def buy_url_method(item)
    do_method_with_item(:buy_url_method, item)
  end

  def image_url_method(item)
    do_method_with_item(:image_url_method, item)
  end

  def do_method_with_item(method, item)
    m = eval self[method]
    perform_method_chain(item, m)
  end
  
  def perform_method_chain(item, method_chain)
    if method_chain.is_a? Symbol
      method_chain == :self ? item : item.send(method_chain)
    elsif method_chain.is_a? String
      methods = method_chain.split(".")
      return eval("item" + (methods.map { |method| ".send(:#{method})" }.join))
    else
      nil
    end
  end
end
