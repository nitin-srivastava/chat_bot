FactoryBot.define do
  factory :message do
    text_message { "Test Message" }
    association :chat, strategy: :build
  end
end
