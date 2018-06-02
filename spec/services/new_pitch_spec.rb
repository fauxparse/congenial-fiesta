# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewPitch, type: :service do
  subject(:service) { NewPitch.new(festival, participant) }
  let(:festival) { create(:festival) }
  let(:participant) { create(:participant) }

  describe '#pitch' do
    subject(:pitch) { service.pitch }

    context 'when this is the first pitch' do
      it 'has an empty presenter bio' do
        expect(pitch.info.presenter.bio).to be_blank
      end
    end

    context 'when this is the second pitch' do
      before do
        participant.pitches.create!(
          festival: festival,
          info: {
            presenter: {
              bio: 'test'
            }
          }
        )
      end

      it 'copies the previous presenter bio' do
        expect(pitch.info.presenter.bio).to eq 'test'
      end
    end
  end
end
