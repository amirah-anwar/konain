class AddFeaturedToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :featured, :boolean, null: false, default: false
  end

  def down
    remove_column :properties, :featured, :boolean
  end
end
