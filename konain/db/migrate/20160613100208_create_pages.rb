class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name, null: false
      t.text :content
      t.string :permalink

      t.timestamps null: false
    end

    add_index :pages, :name
  end
end
