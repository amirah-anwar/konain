class CreateTickers < ActiveRecord::Migration
  def change
    create_table :tickers do |t|
      t.string :title, limit: 20, null: false
      t.text :content, null: false, limit: 255

      t.timestamps null: false
    end
  end
end
