class CreateConversations < ActiveRecord::Migration[6.1]
  def change
    create_table :conversations do |t|
      t.integer :chat_id
      t.string :chat_type
      t.string :title
      t.string :username
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
