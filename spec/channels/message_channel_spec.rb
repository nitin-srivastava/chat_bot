require 'rails_helper'

RSpec.describe MessageChannel, type: :channel do
  describe '#subscribed' do

    it "successfully subscribes" do
      subscribe
      expect(subscription).to be_confirmed
    end
  end
end
