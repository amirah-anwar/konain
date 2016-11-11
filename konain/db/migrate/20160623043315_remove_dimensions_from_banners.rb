class RemoveDimensionsFromBanners < ActiveRecord::Migration
  def up
    remove_column :banners, :dimensions
  end

  def down
    add_column :banners, :dimensions, :string, limit: 30
  end
end
