class AddDimensionToBanner < ActiveRecord::Migration
  def up
    add_column :banners, :dimensions, :string, limit: 30
  end

  def down
    remove_column :banners, :dimensions
  end
end
