Rails.application.routes.draw do
  root to: 'chats#index'
  post "/webhooks/telegram_vbc43edbf166u8ev67s90a954dvd4bfab341", to: 'webhooks#callback', as: :webhooks_callback
end
