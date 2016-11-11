class AddLawyerToUser < ActiveRecord::Migration
  def up
    add_column :users, :lawyer, :boolean, null: false, default: false
  end

  def down
    remove_column :users, :lawyer
  end
end
