# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PitchesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/pitches' do
    it 'is successful' do
      get admin_pitches_path(festival)
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/:year/pitches/:id' do
    let(:pitch) { create(:pitch, :for_workshop, festival: festival) }

    before { pitch.submitted! }

    it 'is successful' do
      get admin_pitch_path(festival, pitch)
      expect(response).to be_successful
    end
  end

  describe 'PUT /admin/:year/pitches/:id' do
    let(:pitch) { create(:pitch, :for_workshop, festival: festival) }

    before { pitch.submitted! }

    def update
      put admin_pitch_path(festival, pitch, params: { pitch: params })
    end

    context 'changing piles' do
      let(:params) { { pile: 'yes' } }

      it 'changes piles' do
        expect { update }
          .to change { pitch.reload.pile }
          .from('unsorted')
          .to('yes')
        expect(response).to redirect_to admin_pitches_path(festival)
      end
    end
  end
end
