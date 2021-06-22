class ChatsController < ApplicationController
  def index
    @chats = Chat.order(:created_at)
  end
end
