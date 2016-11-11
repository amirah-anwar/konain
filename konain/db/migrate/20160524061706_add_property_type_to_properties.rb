class AddPropertyTypeToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :property_type, :string, null: false, limit: 100
    add_column :properties, :property_sub_type, :string, null: false, limit: 100
    add_index :properties, :property_type
    add_index :properties, :property_sub_type
  end

  def down
    remove_index :properties, :property_sub_type
    remove_index :properties, :property_type
    remove_column :properties, :property_type
    remove_column :properties, :property_sub_type
  end
end
