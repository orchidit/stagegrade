class AddDefaultConnectorToRelTypes < ActiveRecord::Migration
  def self.up
    add_column :relationship_types, :default_connector, :string
  end

  def self.down
    remove_column :relationship_types, :default_connector
  end
end
