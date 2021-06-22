require 'rails_helper'

describe 'ApplicationHelper', type: :helper do

  context 'render_message' do
    let(:sent_message) do
      instance_double('Message', :sent? => true, text_message: 'This is sent message')
    end
    let(:received_message) do
      instance_double('Message', :sent? => false, :received? => true, text_message: 'This is received message')
    end

    it { expect(helper.render_message(sent_message)).to eq("<p class='text-end'><span class='item-sent'>This is sent message</span></p>") }
    it { expect(helper.render_message(received_message)).to eq("<p><span class='item-received'>This is received message</span></p>") }
  end
end