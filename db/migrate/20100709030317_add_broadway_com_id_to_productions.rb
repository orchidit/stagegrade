class AddBroadwayComIdToProductions < ActiveRecord::Migration
  def self.up
    add_column :productions, :broadway_com_id, :string
  end

  def self.down
    remove_column :productions, :broadway_com_id
  end
end
