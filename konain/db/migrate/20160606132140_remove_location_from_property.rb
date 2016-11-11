class RemoveLocationFromProperty < ActiveRecord::Migration
  def up
    remove_index :properties, :location
    remove_column :properties, :location
  end

  def down
    add_column :properties, :location, :string, null: false
    add_index :properties, :location
  end
end
