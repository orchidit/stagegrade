class CreatePanels < ActiveRecord::Migration
  def self.up
    create_table :panels do |t|
      t.string :title
      t.integer :order_seq, :default => 0
      t.text :items
      t.string :item_label_method
      t.string :item_detail_label_method
      t.string :item_url_method
      t.string :item_accessory_method
      t.string :image_url_method
      t.string :more_text
      t.string :more_url
      t.timestamps
    end
  end

  def self.down
    drop_table :panels
  end
end
