require 'rails_helper'
RSpec.describe BotMessageService do
  let(:bot_message_service) { BotMessageService.new }
  let(:from_param_hash) do
    {"id"=>1282, "is_bot"=>false, "first_name"=>"Nitin", "last_name"=>"Srivastava", "language_code"=>"en"}
  end
  let(:chat_param_hash) do
    {"id" => 1282, "first_name" => "Test", "last_name" => "User", "type" => "private"}
  end
  let(:message_hash) do
    { "message_id"=>4, "from" => from_param_hash, "chat" => chat_param_hash, "date"=>1624281961, "text"=>"Hi! How are you doing?" }
  end

  describe '#initialize' do
    it { expect(bot_message_service.bot_client).to be_a(Telegram::Bot::Api) }
    it { expect(bot_message_service.errors).to be_empty }
  end

  describe '#receive' do
    context 'when chat is not exist then' do
      before do
        expect(bot_message_service.receive(message_hash)).to be_truthy
      end

      it 'creates a new chat and a message' do
        chat = Chat.last
        expect(Chat.count).to eq(1)
        expect(chat.first_name).to eq(chat_param_hash['first_name'])
        expect(chat.last_name).to eq(chat_param_hash['last_name'])
        expect(chat.telegram_chat_id).to eq(chat_param_hash['id'])
        expect(Message.count).to eq(1)
        expect(Message.last.text_message).to eq(message_hash['text'])
        expect(Message.last.chat_id).to eq(chat.id)
        expect(bot_message_service.errors).to be_empty
      end
    end

    context 'when chat is exist then' do
      let(:chat) do
        build(:chat, telegram_chat_id: chat_param_hash['id'], chat_type: chat_param_hash['type'],
              first_name: chat_param_hash['first_name'], last_name: chat_param_hash['last_name'])
      end

      before do
        expect(chat.save).to be_truthy
        expect(bot_message_service.receive(message_hash)).to be_truthy
      end

      it 'add the message to an existing chat' do
        expect(Chat.count).to eq(1)
        expect(chat.first_name).to eq(chat_param_hash['first_name'])
        expect(chat.last_name).to eq(chat_param_hash['last_name'])
        expect(chat.telegram_chat_id).to eq(chat_param_hash['id'])
        expect(Message.count).to eq(1)
        expect(Message.last.text_message).to eq(message_hash['text'])
        expect(Message.last.chat_id).to eq(chat.id)
        expect(bot_message_service.errors).to be_empty
      end
    end

    context 'when return false then have some errors' do
      let(:chat_param) { chat_param_hash.merge!("id" => nil) }
      before do
        expect(bot_message_service.receive(message_hash.merge('chat' => chat_param))).to be_falsey
      end

      it 'creates a new chat and a message' do
        expect(Chat.count).to eq(0)
        expect(Message.count).to eq(0)
        expect(bot_message_service.errors).not_to be_empty
        expect(bot_message_service.errors).to eq(["Telegram chat can't be blank"])
      end
    end
  end
end