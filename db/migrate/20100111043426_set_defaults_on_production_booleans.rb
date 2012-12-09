class SetDefaultsOnProductionBooleans < ActiveRecord::Migration
  def self.up
    remove_column :productions, :is_on_broadway
    remove_column :productions, :is_musical
    remove_column :productions, :is_for_adults
    remove_column :productions, :is_for_families
    remove_column :productions, :is_for_kids

    add_column :productions, :is_on_broadway, :boolean, :default => false
    add_column :productions, :is_musical, :boolean, :default => false
    add_column :productions, :is_for_adults, :boolean, :default => false
    add_column :productions, :is_for_families, :boolean, :default => false
    add_column :productions, :is_for_kids, :boolean, :default => false
  end

  def self.down
    remove_column :productions, :is_on_broadway
    remove_column :productions, :is_musical
    remove_column :productions, :is_for_adults
    remove_column :productions, :is_for_families
    remove_column :productions, :is_for_kids

    add_column :productions, :is_on_broadway, :boolean
    add_column :productions, :is_musical, :boolean
    add_column :productions, :is_for_adults, :boolean
    add_column :productions, :is_for_families, :boolean
    add_column :productions, :is_for_kids, :boolean
  end
end
