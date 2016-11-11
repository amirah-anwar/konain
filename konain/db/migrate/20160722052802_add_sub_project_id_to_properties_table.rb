class AddSubProjectIdToPropertiesTable < ActiveRecord::Migration
  def change
    add_column :properties, :sub_project_id, :integer
    add_index :properties, :sub_project_id
  end
end
