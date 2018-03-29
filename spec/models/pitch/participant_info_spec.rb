# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::ParticipantInfo do
  subject(:info) { Pitch::ParticipantInfo.new(data) }
  let(:data) { {} }

  describe '#country_code' do
    subject(:country_code) { info.country_code }
    it { is_expected.to eq 'NZ' }
  end

  describe '#country' do
    subject(:country) { info.country }
    it { is_expected.to eq 'New Zealand' }

    describe 'after assignment' do
      before { info.country = 'Australia' }
      it { is_expected.to eq 'Australia' }
    end
  end
end
