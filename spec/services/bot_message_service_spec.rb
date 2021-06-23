require 'rails_helper'
RSpec.describe BotMessageService do
  let(:bot_message_service) { BotMessageService.new }
  let(:from_param_hash) do
    {"id"=>1282, "is_bot"=>false, "first_name"=>"Test", "last_name"=>"User", "language_code"=>"en"}
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
    let(:bot_api_mock) { instance_double('Telegram::Bot::Api mock') }
    context 'when chat is not exist then' do
      before do
        allow_any_instance_of(Chat).to receive(:dispatch).and_return(true)
        allow_any_instance_of(Message).to receive(:dispatch).and_return(true)
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
        expect(Message.last.message_type).to eq('received')
        expect(Message.last.published).to be_truthy
        expect(bot_message_service.errors).to be_empty
      end
    end

    context 'when chat is exist then' do
      let(:chat) do
        build(:chat, telegram_chat_id: chat_param_hash['id'], chat_type: chat_param_hash['type'],
              first_name: chat_param_hash['first_name'], last_name: chat_param_hash['last_name'])
      end

      before do
        allow_any_instance_of(Chat).to receive(:dispatch).and_return(true)
        allow_any_instance_of(Message).to receive(:dispatch).and_return(true)
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
        expect(Message.last.message_type).to eq('received')
        expect(Message.last.published).to be_truthy
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

    context 'when received message is a bot_command' do
      let(:chat) do
        build(:chat, telegram_chat_id: chat_param_hash['id'], chat_type: chat_param_hash['type'],
              first_name: chat_param_hash['first_name'], last_name: chat_param_hash['last_name'])
      end

      let(:response) do
        {"ok"=>true,
         "result"=>
             {"message_id"=>15,
              "from"=>{"id"=> 1844, "is_bot"=>true, "first_name"=>"Nitin Chat Bot", "username"=>"nitin_tg_chat_bot"},
              "chat"=>{"id"=> 1282, "first_name"=>"Test", "last_name"=>"User", "type"=>"private"},
              "date"=> 1624344640,
              "text"=>"Hello! Message from Service class"}}
      end

      before do
        expect(chat.save).to be_truthy
        allow(Telegram::Bot::Api).to receive(:new).and_return(bot_api_mock)
        allow(bot_api_mock).to receive(:send_message).with(chat_id: chat.telegram_chat_id, text: text_reply).and_return(response)
        allow_any_instance_of(Chat).to receive(:dispatch).and_return(true)
        allow_any_instance_of(Message).to receive(:dispatch).and_return(true)
        expect(bot_message_service.receive(message_hash.merge('text' => bot_command))).to be_truthy
      end

      context '/start' do
        let(:bot_command) { "/start" }
        let(:text_reply) { "Hello #{chat.full_name}! Welcome to the Nitin Chat Bot." }
        it 'sends the reply of the command' do
          command_message = Message.first
          reply_message = Message.last
          expect(chat.first_name).to eq(chat_param_hash['first_name'])
          expect(chat.last_name).to eq(chat_param_hash['last_name'])
          expect(chat.telegram_chat_id).to eq(chat_param_hash['id'])
          expect(Message.count).to eq(2)
          # Command message received
          expect(command_message.text_message).to eq(bot_command)
          expect(command_message.chat_id).to eq(chat.id)
          expect(command_message.message_type).to eq('received')
          expect(command_message.published).to be_truthy
          # Command reply sent
          expect(reply_message.text_message).to eq(text_reply)
          expect(reply_message.chat_id).to eq(chat.id)
          expect(reply_message.message_type).to eq('sent')
          expect(reply_message.published).to be_truthy
          expect(bot_message_service.errors).to be_empty
        end
      end

      context '/stop' do
        let(:bot_command) { "/stop" }
        let(:text_reply) { "Bye #{chat.full_name}! Have a great day." }
        it 'sends the reply of the command' do
          command_message = Message.first
          reply_message = Message.last
          expect(chat.first_name).to eq(chat_param_hash['first_name'])
          expect(chat.last_name).to eq(chat_param_hash['last_name'])
          expect(chat.telegram_chat_id).to eq(chat_param_hash['id'])
          expect(Message.count).to eq(2)
          # Command message received
          expect(command_message.text_message).to eq(bot_command)
          expect(command_message.chat_id).to eq(chat.id)
          expect(command_message.message_type).to eq('received')
          expect(command_message.published).to be_truthy
          # Command reply sent
          expect(reply_message.text_message).to eq(text_reply)
          expect(reply_message.chat_id).to eq(chat.id)
          expect(reply_message.message_type).to eq('sent')
          expect(reply_message.published).to be_truthy
          expect(bot_message_service.errors).to be_empty
        end
      end
    end
  end

  describe '#send_message' do
    let(:message) { build(:message, telegram_message_id: nil) }
    let(:bot_api_mock) { instance_double('Telegram::Bot::Api mock') }

    context 'when success' do
      let(:response) do
        {"ok"=>true,
         "result"=>
             {"message_id"=>15,
              "from"=>{"id"=> 1844, "is_bot"=>true, "first_name"=>"Nitin Chat Bot", "username"=>"nitin_tg_chat_bot"},
              "chat"=>{"id"=> 1282, "first_name"=>"Test", "last_name"=>"User", "type"=>"private"},
              "date"=> 1624344640,
              "text"=>"Hello! Message from Service class"}}
      end
      before do
        expect(message.save).to be_truthy
        allow(Telegram::Bot::Api).to receive(:new).and_return(bot_api_mock)
        allow(bot_api_mock).to receive(:send_message).with(chat_id: message.telegram_chat_id, text: message.text_message).and_return(response)
        expect(bot_message_service.send_message(message)).to be_truthy
      end

      it 'updates the message_id field of message' do
        expect(bot_message_service.errors).to be_empty
        expect(message.telegram_message_id).to eq(response['result']['message_id'])
        expect(message.message_at).to eq(Time.at(response['result']['date']))
        expect(Message.last.message_type).to eq('sent')
        expect(message.published).to be_truthy
      end
    end

    context 'when failed' do
      let(:response) do
        {"ok"=>false, "description"=> "Sorry! something went wrong!"}
      end
      before do
        expect(message.save).to be_truthy
        allow(Telegram::Bot::Api).to receive(:new).and_return(bot_api_mock)
        allow(bot_api_mock).to receive(:send_message).with(chat_id: message.telegram_chat_id, text: message.text_message).and_return(response)
        expect(bot_message_service.send_message(message)).to be_falsey
      end

      it 'returns the errors and not update the message_id field of message' do
        expect(bot_message_service.errors).not_to be_empty
        expect(bot_message_service.errors).to eq(["Sorry! something went wrong!"])
        expect(message.telegram_message_id).to be_nil
        expect(message.message_at).to be_nil
        expect(message.published).to be_falsey
      end
    end
  end
end