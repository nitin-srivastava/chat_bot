class Message < ApplicationRecord
  belongs_to :chat

  validates :chat, :text_message, presence: true
end
