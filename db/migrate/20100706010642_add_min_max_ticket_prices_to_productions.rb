class AddMinMaxTicketPricesToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :min_ticket_price, :float
    add_column :productions, :max_ticket_price, :float
  end

  def self.down
    remove_column :productions, :max_ticket_price
    remove_column :productions, :min_ticket_price
  end
end
