class AddProjectIdToProperty < ActiveRecord::Migration
  def up
    add_column :properties, :project_id, :integer
    add_index :properties, :project_id
  end

  def down
    remove_index :properties, :project_id
    remove_column :properties, :project_id
  end
end
