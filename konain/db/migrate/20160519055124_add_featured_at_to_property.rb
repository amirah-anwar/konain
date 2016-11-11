class AddFeaturedAtToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :featured_at, :datetime
  end

  def down
    remove_column :properties, :featured_at
  end
end
