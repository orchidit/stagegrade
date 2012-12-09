require 'test_helper'

class PanelTest < ActiveSupport::TestCase
  def setup
    @panel = Panel.new; @panel.save!
    @panel2 = Panel.new; @panel2.save!
  end

  def test_order_seq_on_create
    assert_equal @panel.order_seq, 0
    assert_equal @panel2.order_seq, 1
  end

  def test_move_up_and_down_at_edges
    @panel.move :up
    assert_equal @panel.order_seq, 0
    assert_equal @panel2.order_seq, 1

    @panel2.move :down
    assert_equal @panel.order_seq, 0
    assert_equal @panel2.order_seq, 1
  end

  def test_move
    @panel.move :down
    @panel2 = Panel.last
    assert_equal @panel.order_seq, 1
    assert_equal @panel2.order_seq, 0

    @panel.move :up
    @panel2 = Panel.last
    assert_equal @panel.order_seq, 0
    assert_equal @panel2.order_seq, 1
  end
end
