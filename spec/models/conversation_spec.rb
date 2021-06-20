require 'rails_helper'

RSpec.describe Conversation, type: :model do
  let(:conversation) { build(:conversation) }

  it 'should initialize with some data' do
    expect(conversation).to be_a_new(Conversation)
    expect(conversation.chat_id).to eq(123)
    expect(conversation.chat_type).to eq('Private')
    expect(conversation.title).to eq('Test Chat')
    expect(conversation.username).to eq('test_user')
    expect(conversation.first_name).to eq('Test')
    expect(conversation.last_name).to eq('User')
  end
end
