class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.string :title, limit: 20, null: false
      t.boolean :apply, null: false, default: false

      t.timestamps null: false
    end
  end
end
