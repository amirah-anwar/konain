class CreateFavourites < ActiveRecord::Migration
  def up
    create_table :favourites do |t|
      t.string :favourited_type, null: false
      t.integer :favourited_id, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end

    add_index :favourites, [:favourited_type, :favourited_id]
    add_index :favourites, :user_id
  end
end
