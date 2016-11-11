class AddClosedAtEndPriceToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :closed_at, :datetime
    add_column :properties, :end_price, :integer, null: false, default: 0
    add_index :properties, :end_price
    add_index :properties, :closed_at
  end

  def down
    remove_index :properties, :closed_at
    remove_index :properties, :end_price
    remove_column :properties, :end_price
    remove_column :properties, :closed_at
  end
end
