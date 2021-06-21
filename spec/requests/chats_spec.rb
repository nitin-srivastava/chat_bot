require 'rails_helper'

RSpec.describe "Chat", type: :request do
  let(:chat) { build(:chat) }
  let(:chat_two) do
    build(:chat, telegram_chat_id: 234, title: 'Test Chat 2', username: 'test_user_2', first_name: 'Test', last_name: 'User 2')
  end

  describe "GET /" do
    before do
      expect(chat.save).to be_truthy
      expect(chat_two.save).to be_truthy
      get "/"
    end
    it "returns http success and data" do
      expect(response).to have_http_status(:success)
      expect(assigns[:chats]).to match_array([chat, chat_two])
    end
  end

end
