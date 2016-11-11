class RemoveColumnsFromProperties < ActiveRecord::Migration
  def up
    remove_column :properties, :expire_at
    remove_column :properties, :negotiable
  end

  def down
    add_column :properties, :expire_at, :datetime
    add_column :properties, :negotiable, :boolean, default: false, null: false
  end
end
