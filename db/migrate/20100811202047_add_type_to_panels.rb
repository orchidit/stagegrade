class AddTypeToPanels < ActiveRecord::Migration
  def self.up
    add_column :panels, :type, :string
    Panel.reset_column_information
    Panel.all.each { |p| p.type = "ProductionPanel"; p.save! }
  end

  def self.down
    remove_column :panels, :type
  end
end
