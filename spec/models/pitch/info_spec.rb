# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::Info do
  subject(:info) { Pitch::Info.new(data) }
  let(:data) { {} }

  describe '#participant' do
    subject(:participant) { info.participant }
    it { is_expected.to be_a Pitch::ParticipantInfo }

    context 'when data exists' do
      let(:data) { { participant: { name: 'Test' } } }

      it 'has the right data' do
        expect(info.participant.name).to eq 'Test'
      end
    end
  end
end
