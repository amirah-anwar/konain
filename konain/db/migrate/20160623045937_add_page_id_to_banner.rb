class AddPageIdToBanner < ActiveRecord::Migration
  def up
    add_column :banners, :page_id, :integer
  end

  def down
    remove_column :banners, :page_id
  end
end
