class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false, limit: 30
      t.text :description, limit: 500
      t.string :city, null: false
      t.string :country, null: false
      t.string :location, null: false, limit: 60

      t.timestamps null: false
    end

    add_index :projects, :city
    add_index :projects, :country
  end
end
