class AddNullFalseToHomePhoneInUsers < ActiveRecord::Migration
  def up
    change_column :users, :home_phone, :string, null: false, limit: 50
  end

  def down
    change_column :users, :home_phone, :string, null: true
  end
end
