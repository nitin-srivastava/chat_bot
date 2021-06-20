require 'rails_helper'

RSpec.describe "Conversations", type: :request do
  let(:conversation) { build(:conversation) }
  let(:conversation_two) do
    build(:conversation, chat_id: 234, title: 'Test Chat 2', username: 'test_user_2', first_name: 'Test', last_name: 'User 2')
  end

  describe "GET /" do
    before do
      expect(conversation.save).to be_truthy
      expect(conversation_two.save).to be_truthy
      get "/"
    end
    it "returns http success and data" do
      expect(response).to have_http_status(:success)
      expect(assigns[:conversations]).to match_array([conversation, conversation_two])
    end
  end

end
