class RemoveCoverFieldFromAttachments < ActiveRecord::Migration
  def up
    remove_column :attachments, :cover, :boolean
  end

  def down
    add_column :attachments, :cover, :boolean, null: false, default: false
  end
end
