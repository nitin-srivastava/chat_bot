class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    bot_msg_service = BotMessageService.new
    if bot_msg_service.receive(params[:message])
      render status: :ok, plain: 'OK'
    else
      render status: :unprocessable_entity, plain: 'OK'
    end
  end
end