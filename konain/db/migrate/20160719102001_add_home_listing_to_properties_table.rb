class AddHomeListingToPropertiesTable < ActiveRecord::Migration
  def up
    add_column :properties, :home_listing, :boolean, null: false, default: false
  end

  def down
    remove_column :properties, :home_listing, :boolean
  end
end
