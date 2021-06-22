class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.references :chat, null: false, foreign_key: true
      t.integer :telegram_message_id
      t.text :text_message
      t.datetime :post_at

      t.timestamps
    end
  end
end
