class CreateProperties < ActiveRecord::Migration
  def change
    create_table :properties do |t|
      t.string :category, null: false, limit: 30
      t.string :city, null: false, limit: 60
      t.string :location, null: false
      t.string :title, null: false
      t.text :description
      t.integer :price, null: false, default: 0
      t.float :land_area, null: false
      t.string :area_unit, null: false, limit: 20
      t.integer :bedroom_count, null: false, default: 0
      t.integer :bathroom_count, null: false, default: 0
      t.datetime :expire_at
      t.boolean :negotiable, null: false, default: false

      t.timestamps null: false
    end

    add_index :properties, :bedroom_count
    add_index :properties, :bathroom_count
    add_index :properties, :location
    add_index :properties, :city
    add_index :properties, :price
  end
end
