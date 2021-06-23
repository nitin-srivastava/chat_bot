import consumer from "./consumer"

consumer.subscriptions.create("MessageChannel", {
  received(data) {
    if($('#chat-channel-' + data['chat_id'] +' a').hasClass('active')) {
      this.appendMessageLine(data['message_body']);
    }
  },

  appendMessageLine(message) {
    $("#message-items").append(message);
    let chatWindow = $("#active-chat-window div:first-child");
    let scrollHeight = parseInt(chatWindow[0].scrollHeight);
    let elementHeight = parseInt(chatWindow.height());
    chatWindow.animate({ scrollTop: (scrollHeight - elementHeight)});
  }
});
