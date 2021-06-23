class Message < ApplicationRecord
  belongs_to :chat
  include ApplicationHelper

  MESSAGE_TYPES = %w[received sent].freeze
  validates :chat, :text_message, :message_type, presence: true
  validates :message_type, inclusion: { in: MESSAGE_TYPES, message: "%{value} is not a valid message type"  }

  delegate :telegram_chat_id, to: :chat, allow_nil: true, prefix: false

  scope :published, -> { where(published: true) }

  MESSAGE_TYPES.each do |name|
    define_method("#{name}?") do
      message_type == name
    end
  end

  def save_and_publish
    self.message_type = 'sent'
    self.save
    if BotMessageService.new.send_message(self)
      dispatch
      true
    end
  end

  def dispatch
    ActionCable.server.broadcast("message_channel", message_channel_data(self))
  end
end
