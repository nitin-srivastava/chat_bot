# Chat App
## About
This is a chat app which consume Telegram API to send and receive messages.
### Required Ruby, Rails and DB
Ruby version `3.0.1` 

Rails version `>= 6.1.3.2`

Sqlite database

You must have Docker installed in your development machine.

### Instruction to install and run
#### Github repo access
I have added you as a contributor, hope you have access. Write me back If you still don't have access.

### Telegram API webhook setup
Using Telegram webhooks to receive the messages. Here are the steps to setup the webhook on development environment.
1. Install `ngrok` to your development machine
 
   For Mac
   
   `$brew cask install ngrok`
   
   For Linux
   
   ```
   $sudo apt update
   $sudo apt install snapd
   $sudo snap install ngrok
   ```
2. Start `ngrok`
   ```
    $ngrok http 3000
   ```
3. Copy the forwarding url (see screenshot) and set it to `NGROK_HOST` in `.env` file. Like
   ![ngrok-img](https://user-images.githubusercontent.com/24418296/123465057-45dc9380-d60b-11eb-8fc9-cc9186fc7aa0.png)

   ```
   export NGROK_HOST=47f5876d8139.ngrok.io
   ``` 

4. Set the [Telegram webhook](https://core.telegram.org/bots/api#setwebhook) by using a secret path in the URL. This secret path contains api path/token/setWebhook? and url params. Example

   `https://api.telegram.org/bot<token>/setWebhook?url=<forwarding url created in step 3>/<callback action>`
   
   Use below URL with forwarding url
   ```
   https://api.telegram.org/bot1844507094:AAG3UzxBzv1kheb6Bru1gRCk-m8WlY0siAE/setWebhook?url=<forwarding-url>/webhooks/telegram_vbc43edbf166u8ev67s90a954dvd4bfab341
   ```
   It returns a response like below if all went well.
   ```
   {"ok":true,"result":true,"description":"Webhook was set"}
   ```
### Docker
I have package this app using docker. Use below commands to install and run the app.

   ```
   git clone https://github.com/ledermann/chat_bot.git
   cd chat_bot
   docker-compose build
   docker-compose up
   ``` 

## Test and Code coverage
Time to test the app once installation went well. Open Telegram in your mobile/laptop and search **Nitin Chat Bot** and start conversation.
 
### Rspec
Used `rspec` for testing. Below command will run the test suits.
```
$ bundle exec rspec
```

### Code coverage 
Used `simplecov` gem for the test coverage and achieved 100% code coverage. To see the code coverage report open the `coverage/index.html` file in the browser after running the `rspec`. Screenshot attached
![test_coverage](https://user-images.githubusercontent.com/24418296/123465156-63a9f880-d60b-11eb-9c35-dd448a0cfa68.png)


### Demo video
Attached is a demo video
https://user-images.githubusercontent.com/24418296/123467351-0c595780-d60e-11eb-8a83-7f1a29e86c4b.mp4


Hope you found the given instructions helpful.

## Developer
Nitin Srivastava
