class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :sender_name
      t.integer :agent_id, null: false
      t.text :body
      t.string :contact
      t.string :user_email

      t.timestamps null: false
    end
    add_index :emails, :agent_id
  end
end
