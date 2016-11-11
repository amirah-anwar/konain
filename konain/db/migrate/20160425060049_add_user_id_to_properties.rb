class AddUserIdToProperties < ActiveRecord::Migration
  def up
    add_column :properties, :user_id, :integer, null: false
    add_index :properties, :user_id
  end

  def down
    remove_index :properties, :user_id
    remove_column :properties, :user_id
  end
end
