FactoryBot.define do
  factory :chat do
    telegram_chat_id { 123 }
    chat_type { "Private" }
    title { "Test Chat" }
    username { "test_user" }
    first_name { "Test" }
    last_name { "User" }
  end
end
