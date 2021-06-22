class MessagesController < ApplicationController
  before_action :set_chat

  def index
    @messages = @chat.messages.published
    respond_to do |format|
      format.js {}
    end
  end

  def create
    @message = @chat.messages.new(message_params)
    @message.save_and_publish
    respond_to do |format|
      format.js {}
    end
  end

  private

  def set_chat
    @chat = Chat.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:text_message)
  end
end
