class AddMapFieldsToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :latitude, :decimal, precision: 16, scale: 13
    add_column :properties, :longitude, :decimal, precision: 16, scale: 13
  end
end
