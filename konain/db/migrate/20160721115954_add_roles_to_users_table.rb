class AddRolesToUsersTable < ActiveRecord::Migration
  def up
    add_column :users, :role, :string, limit: 30
    remove_column :users, :admin
    remove_column :users, :lawyer
    remove_column :users, :is_agent
  end

  def down
    remove_column :users, :role
    add_column :users, :admin, :boolean, null: false, default: false
    add_column :users, :lawyer, :boolean, null: false, default: false
    add_column :users, :is_agent, :boolean, null: false, default: false
  end
end
