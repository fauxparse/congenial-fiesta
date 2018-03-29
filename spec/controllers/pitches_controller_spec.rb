# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchesController, type: :request do
  subject { response }

  context 'when logged in' do
    before { log_in_as(participant) }
    let(:participant) { create(:participant, :with_password) }

    describe 'get /pitches' do
      before { get pitches_path }
      it { is_expected.to be_successful }
    end

    describe 'get /pitch' do
      before { get new_pitch_path }
      it { is_expected.to be_successful }
    end

    describe 'post /pitch' do
      before { post new_pitch_path, params: { pitch: pitch_params } }
      let(:pitch_params) do
        {
          participant: {
            name: participant.name,
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep'
          },
          code_of_conduct: '1'
        }
      end
      let(:pitch) { participant.pitches.last }
      let(:next_step) { pitch_step_path(pitch, :activity_info) }

      it 'creates a pitch' do
        expect(pitch).not_to be_nil
      end

      it { is_expected.to redirect_to next_step }

      context 'when information is only partially completed' do
        let(:pitch_params) do
          { participant: { city: 'Melbourne' } }
        end
        let(:same_step) { pitch_step_path(pitch, :participant_info) }

        it 'still creates a pitch' do
          expect(pitch).not_to be_nil
        end

        it 'renders the form' do
          expect(response).to be_successful
        end
      end
    end

    describe 'get /pitch/:id/participant_info' do
      before { get pitch_step_path(pitch, :participant_info) }
      let(:pitch) { create(:pitch, participant: participant) }

      it { is_expected.to be_successful }
    end

    describe 'get /pitch/:id/activity_info' do
      before do
        post new_pitch_path, params: { pitch: pitch_params }
        get pitch_step_path(pitch, :activity_info)
      end
      let(:pitch_params) do
        {
          participant: {
            name: participant.name,
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep'
          },
          code_of_conduct: '1'
        }
      end
      let(:pitch) { participant.pitches.last }

      it { is_expected.to be_successful }
    end

    describe 'put /pitch/:id/participant_info' do
      before { put pitch_step_path(pitch, :participant_info), params: params }
      let(:pitch) { create(:pitch, participant: participant) }
      let(:params) do
        {
          pitch: { participant: { name: 'Updated' } }
        }
      end

      it { is_expected.to be_successful }

      it 'updates the pitch' do
        expect(pitch.reload.info.participant.name).to eq 'Updated'
      end
    end
  end

  context 'when not logged in' do
    describe 'get /pitches' do
      before { get pitches_path }
      it { is_expected.to redirect_to login_path }
    end

    describe 'get /pitch' do
      before { get new_pitch_path }
      it { is_expected.to be_successful }
    end

    describe 'post /pitch' do
      before { post new_pitch_path, params: { pitch: pitch_params } }
      let(:pitch_params) do
        {
          participant: {
            name: 'Test participant',
            email: 'test@example.com',
            password: 'p4$$w0rd',
            password_confirmation: 'p4$$w0rd',
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep'
          },
          code_of_conduct: '1'
        }
      end
      let(:pitch) { Pitch.last }
      let(:next_step) { pitch_step_path(pitch, :activity_info) }

      it 'creates a pitch' do
        expect(pitch).not_to be_nil
      end

      it 'creates a participant' do
        expect(pitch.participant).to be_persisted
        expect(pitch.participant.name).to eq 'Test participant'
      end

      it { is_expected.to redirect_to next_step }
    end
  end
end
