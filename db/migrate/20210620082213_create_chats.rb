class CreateChats < ActiveRecord::Migration[6.1]
  def change
    create_table :chats do |t|
      t.integer :telegram_chat_id
      t.string :chat_type
      t.string :title
      t.string :username
      t.string :first_name
      t.string :last_name

      t.timestamps
    end
  end
end
