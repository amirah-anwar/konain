class ChangePriceColumnsInProperties < ActiveRecord::Migration
  def up
    change_column :properties, :price, :integer, limit: 8
    change_column :properties, :end_price, :integer, limit: 8
  end

  def down
    change_column :properties, :price, :integer, limit: 4
    change_column :properties, :end_price, :integer, limit: 4
  end
end
