require 'rails_helper'

RSpec.describe "Messages", type: :request do
  let(:chat) { create(:chat) }
  let(:message) { build(:message, text_message: 'Message one', chat: chat, published: true) }
  let(:message_two) { build(:message, text_message: 'Message two', chat: chat, published: true) }

  describe "GET /index" do
    before do
      expect(message.save).to be_truthy
      expect(message_two.save).to be_truthy
      get chat_messages_path(chat.id), xhr: true
    end

    it 'returns messages and render index.js' do
      expect(assigns[:chat]).to eq(chat)
      expect(assigns[:messages]).to match_array([message, message_two])
      expect(response).to render_template('messages/index')
    end
  end

  describe "POST /create" do
    let(:bot_service_mock) { instance_double('BotMessageService') }
    before do
      allow(BotMessageService).to receive(:new).and_return(bot_service_mock)
      allow(bot_service_mock).to receive(:send_message).and_return(true)
      post chat_messages_path(chat.id), params: { message: { text_message: 'Test text message.' } }, xhr: true
    end

    it 'creates a message and render create.js' do
      expect(assigns[:chat]).to eq(chat)
      expect(assigns[:message]).to eq(Message.last)
      expect(response).to render_template('messages/create')
    end
  end
end
