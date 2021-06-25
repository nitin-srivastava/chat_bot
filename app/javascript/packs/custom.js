scrollToTheLastItem = function() {
    let chatWindow = $("#active-chat-window div:first-child");
    let scrollHeight = parseInt(chatWindow[0].scrollHeight);
    let elementHeight = parseInt(chatWindow.height());
    chatWindow.animate({ scrollTop: (scrollHeight - elementHeight)});
}