require 'rails_helper'

RSpec.describe Chat, type: :model do
  let(:chat) { build(:chat) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:telegram_chat_id) }
    it { is_expected.to validate_uniqueness_of(:telegram_chat_id) }
  end

  it 'should initialize with some data' do
    expect(chat).to be_a_new(Chat)
    expect(chat.telegram_chat_id).to eq(123)
    expect(chat.chat_type).to eq('Private')
    expect(chat.title).to eq('Test Chat')
    expect(chat.username).to eq('test_user')
    expect(chat.first_name).to eq('Test')
    expect(chat.last_name).to eq('User')
  end

  describe '#full_name' do
    let(:chat_two) { build(:chat, first_name: 'Tarek', last_name: ' ' ) }

    it { expect(chat.full_name).to eq('Test User') }
    it { expect(chat_two.full_name).to eq('Tarek') }
  end
end
