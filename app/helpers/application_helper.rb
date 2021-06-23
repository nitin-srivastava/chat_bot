module ApplicationHelper

  def render_message(message)
    if message.sent?
      "<p class='text-end'><span class='item-sent'>#{message.text_message}</span></p>"
    elsif message.received?
      "<p><span class='item-received'>#{message.text_message}</span></p>"
    end.html_safe
  end
end
