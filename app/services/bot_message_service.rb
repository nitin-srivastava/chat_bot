require 'telegram/bot'
class BotMessageService
  attr_accessor :bot_client, :errors

  def initialize
    token = Rails.application.credentials.telegram[:bot][:token]
    @bot_client = Telegram::Bot::Api.new(token)
    @errors = []
  end

  def receive(message_hash)
    chat = find_or_create_chat(message_hash['chat'])
    message = chat.messages.new(telegram_message_id: message_hash['message_id'],
                                text_message: message_hash['text'],
                                message_at: Time.at("#{message_hash['date']}".to_i),
                                message_type: 'received', published: true)
    if save_record(message)
      message.dispatch
      send_comand_answer(chat, message) if message.bot_command?
      true
    end
  rescue StandardError => e
    errors.push(e.message)
    false
  end

  def send_message(message)
    response = bot_client.send_message(chat_id: message.telegram_chat_id, text: message.text_message)
    parse_response(response, message)
  end

  private

  def find_or_create_chat(param_hash)
    chat = Chat.find_or_initialize_by(telegram_chat_id: param_hash['id'])
    return chat unless chat.new_record?
    chat.assign_attributes(first_name: param_hash['first_name'],
                           last_name: param_hash['last_name'],
                           chat_type: param_hash['type'])
    if save_record(chat)
      chat.dispatch
      chat
    end
  end

  def save_record(record)
    return true if record.save
    raise StandardError, record.errors.full_messages.join(', ')
  end

  def parse_response(response, message)
    if response['ok']
      result = response['result']
      message.update_columns(telegram_message_id: result['message_id'],
                             message_at: Time.at(result['date']), published: true)
    else
      errors.push(response['description'])
    end
    response['ok']
  end

  def send_comand_answer(chat, c_message)
    _message = chat.messages.new(text_message: command_text(c_message))
    _message.save_and_publish
  end

  def command_text(c_message)
    case c_message.text_message
    when '/start'
      "Hello #{c_message.chat.full_name}! Welcome to the Nitin Chat Bot."
    when '/stop'
      "Bye #{c_message.chat.full_name}! Have a great day."
    end
  end
end