class RenameConnectorOnRelationships < ActiveRecord::Migration
  def self.up
    add_column :relationships, :custom_connector, :string
    Relationship.reset_column_information
    Relationship.all.each { |rel| rel.custom_connector = rel.connector; rel.save! }
    remove_column :relationships, :connector
  end

  def self.down
    add_column :relationships, :connector, :string
    Relationship.reset_column_information
    Relationship.all.each { |rel| rel.connector = rel.custom_connector; rel.save! }
    remove_column :relationships, :custom_connector
  end
end
