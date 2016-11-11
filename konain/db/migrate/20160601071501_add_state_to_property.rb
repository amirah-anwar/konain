class AddStateToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :state, :string, default: "pending", null: false
    add_index :properties, :state
  end

  def down
    remove_index :properties, :state
    remove_column :properties, :state
  end
end
