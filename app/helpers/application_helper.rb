module ApplicationHelper

  def render_message(message)
    if message.sent?
      "<p class='text-end'><span class='item-sent'>#{message.text_message}</span></p>"
    elsif message.received?
      "<p><span class='item-received'>#{message.text_message}</span></p>"
    end.html_safe
  end

  private

  def message_channel_data(message)
    {
      chat_id: message.chat_id,
      message_body: render_message(message)
    }
  end

  def chat_channel_data(chat)
    {
      chat_id: chat.id,
      chat_name: ApplicationController.renderer.render(partial: 'chats/nav_item', locals: { chat: chat })
    }
  end
end
