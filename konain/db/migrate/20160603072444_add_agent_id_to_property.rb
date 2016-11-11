class AddAgentIdToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :agent_id, :integer
    add_index :properties, :agent_id
  end

  def down
    remove_index :properties, :agent_id
    remove_column :properties, :agent_id
  end
end
