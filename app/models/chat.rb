class Chat < ApplicationRecord
  has_many :messages

  validates :first_name, :telegram_chat_id, presence: true
  validates :telegram_chat_id, uniqueness: true
end
