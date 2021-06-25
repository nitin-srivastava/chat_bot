import consumer from "./consumer"

consumer.subscriptions.create("MessageChannel", {
  received(data) {
    if($('#chat-channel-' + data['chat_id'] +' a').hasClass('active')) {
      this.appendMessageLine(data['message_body']);
    }
  },

  appendMessageLine(message) {
    $("#message-items").append(message);
    scrollToTheLastItem();
  }
});
