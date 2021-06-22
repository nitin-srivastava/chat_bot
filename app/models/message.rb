class Message < ApplicationRecord
  belongs_to :chat

  validates :chat, :text_message, :message_type, presence: true
  validates :message_type, inclusion: { in: %w[received sent], message: "%{value} is not a valid message type"  }

  delegate :telegram_chat_id, to: :chat, allow_nil: true, prefix: false
end
