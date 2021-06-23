require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:chat) }
  end

  describe 'validations' do
    let(:message) { build(:message) }

    it 'has the below validations' do
      expect(message).to validate_presence_of(:chat)
      expect(message).to validate_presence_of(:text_message)
      expect(message).to validate_presence_of(:message_type)
      expect(message).to allow_value('received').for(:message_type)
      expect(message).to allow_value('sent').for(:message_type)
      expect(message).not_to allow_value('hello').for(:message_type).with_message("hello is not a valid message type")
    end
  end

  describe "#sent?" do
    let(:message) { build(:message) }

    it { expect(message.sent?).to be_truthy }
    it { expect(message.received?).to be_falsey }
  end

  describe "#received?" do
    let(:message) { build(:message, message_type: 'received') }

    it { expect(message.sent?).to be_falsey }
    it { expect(message.received?).to be_truthy }
  end

  describe '#save_and_publish' do
    let(:chat) { create(:chat) }
    let(:message) { build(:message, chat: chat) }
    let(:bot_service_mock) { instance_double('BotMessageService') }

    before do
      allow(BotMessageService).to receive(:new).and_return(bot_service_mock)
      allow(bot_service_mock).to receive(:send_message).and_return(true)
    end

    it 'saves and publish the message' do
      expect(message.save_and_publish).to be_truthy
    end
  end

  describe '#dispatch' do
    let(:message) { build(:message) }
    let(:action_cable_mock) { instance_double("ActionCable class") }
    before do
      allow(ActionCable).to receive(:server).and_return(action_cable_mock)
      allow(action_cable_mock).to receive(:broadcast).and_return(nil)
      expect(message.save).to be_truthy
    end

    it { expect(message.dispatch).to be_nil }
  end

  describe '#bot_command?' do
    let(:message) { build(:message) }
    let(:start_message) { build(:message, text_message: "/start") }
    let(:stop_message) { build(:message, text_message: "/stop") }

    it 'returns the boolean true/false value' do
      expect(message.bot_command?).to be_falsey
      expect(start_message.bot_command?).to be_truthy
      expect(stop_message.bot_command?).to be_truthy
    end
  end
end
