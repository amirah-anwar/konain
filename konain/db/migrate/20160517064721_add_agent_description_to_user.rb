class AddAgentDescriptionToUser < ActiveRecord::Migration
  def up
    add_column :users, :agent_description, :text
  end

  def down
    remove_column :users, :agent_description
  end
end
