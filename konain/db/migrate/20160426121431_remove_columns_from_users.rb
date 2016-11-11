class RemoveColumnsFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :fax
    remove_column :users, :address
    remove_column :users, :zip_code
    remove_column :users, :country
  end

  def down
    add_column :users, :fax, :string, limit: 50
    add_column :users, :address, :string
    add_column :users, :zip_code, :string, limit: 15
    add_column :users, :country, :string, limit: 50
  end
end
