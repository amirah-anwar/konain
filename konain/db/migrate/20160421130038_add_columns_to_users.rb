class AddColumnsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :name, :string, null: false, limit: 50
    add_column :users, :mobile_phone, :string, null: false, limit: 50
    add_column :users, :is_agent, :boolean, null: false, default: false
    add_column :users, :home_phone, :string, limit: 50
    add_column :users, :fax, :string, limit: 50
    add_column :users, :address, :string
    add_column :users, :zip_code, :string, limit: 15
    add_column :users, :country, :string, limit: 50

  end

  def down
    remove_column :users, :name
    remove_column :users, :mobile_phone
    remove_column :users, :is_agent
    remove_column :users, :home_phone
    remove_column :users, :fax
    remove_column :users, :address
    remove_column :users, :zip_code
    remove_column :users, :country
  end
end
