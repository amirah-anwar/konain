class AddSubscriberToUsers < ActiveRecord::Migration
  def up
    add_column :users, :subscriber, :boolean
  end

  def down
    remove_column :users, :subscriber, :boolean
  end
end
