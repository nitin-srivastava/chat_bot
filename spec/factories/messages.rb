FactoryBot.define do
  factory :message do
    telegram_message_id { 987 }
    text_message { "Test Message" }
    association :chat, strategy: :build
  end
end
