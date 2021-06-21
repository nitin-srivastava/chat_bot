require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:chat) { build(:chat) }

  it 'should initialize with some data' do
    expect(chat).to be_a_new(Chat)
    expect(chat.telegram_chat_id).to eq(123)
    expect(chat.telegram_chat_type).to eq('Private')
    expect(chat.title).to eq('Test Chat')
    expect(chat.username).to eq('test_user')
    expect(chat.first_name).to eq('Test')
    expect(chat.last_name).to eq('User')
  end
end
