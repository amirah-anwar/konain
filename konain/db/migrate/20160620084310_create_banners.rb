class CreateBanners < ActiveRecord::Migration
  def change
    create_table :banners do |t|
      t.string :name, limit: 100

      t.timestamps null: false
    end
  end
end
