class Message < ApplicationRecord
  belongs_to :chat

  validates :chat, :text_message, presence: true

  delegate :telegram_chat_id, to: :chat, allow_nil: true, prefix: false
end
