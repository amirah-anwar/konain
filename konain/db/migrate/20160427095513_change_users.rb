class ChangeUsers < ActiveRecord::Migration
  def up
    remove_column :users, :mobile_phone
    remove_column :users, :home_phone
    add_column :users, :mobile_phone_code, :string, null: false, limit: 10
    add_column :users, :mobile_phone_number, :string, null: false, limit: 20
    add_column :users, :home_phone_code, :string, null: false, limit: 10
    add_column :users, :home_phone_number, :string, null: false, limit: 20
  end

  def down
    add_column :users, :mobile_phone, :string, null: false, limit: 50
    add_column :users, :home_phone, :string, null: false, limit: 50
    remove_column :users, :mobile_phone_code
    remove_column :users, :mobile_phone_number
    remove_column :users, :home_phone_code
    remove_column :users, :home_phone_number
  end
end
