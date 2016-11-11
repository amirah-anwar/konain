class AddDeltaColumnToProperty < ActiveRecord::Migration
  def change
    add_column :properties, :delta, :boolean, default: true, null: false
  end
end
