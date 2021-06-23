class Chat < ApplicationRecord
  include ApplicationHelper
  has_many :messages

  validates :first_name, :telegram_chat_id, presence: true
  validates :telegram_chat_id, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".rstrip
  end

  def dispatch
    data = chat_channel_data(self)
    ActionCable.server.broadcast('chat_channel', data)
  end
end
