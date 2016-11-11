class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :fax_number, :string, limit: 20
    add_column :users, :fax_code, :string, limit: 10
    add_column :users, :city, :string, limit: 50
    add_column :users, :country, :string, limit: 50
    add_column :users, :zip_code, :string, limit: 15
    add_column :users, :address, :string
  end
end
