class AddPropertyFeaturesToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :property_features, :string
  end

  def down
    remove_column :properties, :property_features
  end
end
