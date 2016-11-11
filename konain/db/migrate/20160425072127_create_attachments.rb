class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.string :imageable_type, null: false
      t.integer :imageable_id, null: false

      t.timestamps null: false
    end

    add_index :attachments, [:imageable_id, :imageable_type]
  end
end
