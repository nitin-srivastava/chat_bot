import consumer from "./consumer"

consumer.subscriptions.create("ChatChannel", {
  received(data) {
    this.appendChatRow(data);
  },

  appendChatRow(data) {
    if($("#chats-list #chat-channel-" + data['chat_id'] + "").length == 0) {
      $("#chats-list").append(data['chat_name']);
    }
  }
});
