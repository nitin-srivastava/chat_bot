class ConversationsController < ApplicationController
  def index
    @conversations = Conversation.order(:created_at)
  end
end
