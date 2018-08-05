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
      put admin_pitch_path(festival, pitch), params: { pitch: params }
    end

    context 'changing piles' do
      let(:params) { { pile: 'yes' } }

      it 'changes piles' do
        expect { update }
          .to change { pitch.reload.pile }
          .from('unsorted')
          .to('yes')
        expect(response).to redirect_to admin_pitch_path(festival, pitch)
      end
    end
  end

  describe 'GET /admin/:year/pitches/convert' do
    let(:pitch) { create(:pitch, :for_workshop, festival: festival) }

    it 'is successful' do
      get select_admin_pitches_path(festival)
      expect(response).to be_successful
    end
  end

  describe 'POST /admin/:year/pitches/convert' do
    let!(:pitch) do
      create(:pitch, :for_workshop, festival: festival, status: :submitted)
    end

    def do_convert
      post select_admin_pitches_path(festival), params: params
    end

    context 'with ids' do
      let(:params) { { id: [pitch.to_param] } }

      it 'converts the pitch to a workshop' do
        expect { do_convert }.to change(Workshop, :count).by(1)
      end

      it 'redirects to the pitches page' do
        do_convert
        expect(response).to redirect_to admin_pitches_path(festival)
        expect(flash[:notice]).to match(/1 activity created/)
      end

      context 'when the pitch has already been converted' do
        before { ConvertPitch.new(pitch).call }

        it 'does not create a workshop' do
          expect { do_convert }.not_to change(Workshop, :count)
          expect(response).to redirect_to admin_pitches_path(festival)
          expect(flash[:notice]).to match(/Nothing/)
        end
      end
    end

    context 'without ids' do
      let(:params) { {} }

      it 'does not create a workshop' do
        expect { do_convert }.not_to change(Workshop, :count)
      end
    end
  end
end
