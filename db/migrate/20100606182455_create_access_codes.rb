class CreateAccessCodes < ActiveRecord::Migration
  def self.up
    create_table :access_codes do |t|
      t.string :code
      t.string :email_expression
      t.integer :role_id
      t.integer :uses, :default => 0
      t.integer :max_uses
      t.boolean :is_active, :default => true
      t.timestamps
    end
  end

  def self.down
    drop_table :access_codes
  end
end
