require 'rails_helper'

RSpec.describe "Webhooks", type: :request do

  describe "POST /callback" do
    let(:message_params) do
      { message_id: 9876, date: 1624281961, text: "Hi! How are you doing?",
        from: chat_param, chat: chat_param }
    end

    before do
      post webhooks_callback_url, params: { message: message_params }
    end

    context 'success' do
      let(:chat_param) do
        { id: 1282, first_name: "Test", last_name: "User" }
      end

      it "returns http success and create some records" do
        expect(response).to have_http_status(:success)
        expect(Chat.count).to eq(1)
        expect(Message.count).to eq(1)
      end
    end

    context 'unprocessed' do
      let(:chat_param) do
        { id: nil, first_name: "Test", last_name: "User" }
      end

      it "returns http unprocessable_entity and should not create any records" do
        expect(response).to have_http_status(:unprocessable_entity)
        expect(Chat.count).to eq(0)
        expect(Message.count).to eq(0)
      end
    end
  end

end
