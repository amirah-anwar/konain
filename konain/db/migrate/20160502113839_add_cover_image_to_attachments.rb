class AddCoverImageToAttachments < ActiveRecord::Migration
  def up
    add_column :attachments, :cover, :boolean, null: false, default: false
  end

  def down
    remove_column :attachments, :cover, :boolean
  end
end
