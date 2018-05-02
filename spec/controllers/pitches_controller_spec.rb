# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchesController, type: :request do
  subject { response }
  let!(:festival) { create(:festival) }
  let(:pitch) { create(:pitch, participant: participant, festival: festival) }

  context 'when logged in' do
    before { log_in_as(participant) }
    let(:participant) { create(:participant, :with_password) }

    describe 'get /pitches' do
      before do
        pitch
        get pitches_path
      end

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
          presenter: {
            name: participant.name,
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep',
            availability: 'yes'
          },
          code_of_conduct: '1'
        }
      end
      let(:pitch) { participant.pitches.last }
      let(:next_step) { pitch_step_path(pitch, :idea) }

      it 'creates a pitch' do
        expect(pitch).not_to be_nil
      end

      it { is_expected.to redirect_to next_step }

      context 'when information is only partially completed' do
        let(:pitch_params) do
          { participant: { city: 'Melbourne' } }
        end

        it 'still creates a pitch' do
          expect(pitch).not_to be_nil
        end

        it 'renders the form' do
          expect(response).to be_successful
        end
      end
    end

    describe 'get /pitch/:id' do
      context 'for a draft pitch' do
        before { get pitch_path(pitch) }
        it { is_expected.to redirect_to pitch_step_path(pitch, :presenter) }
      end

      context 'for a submitted pitch' do
        before do
          pitch.submitted!
          get pitch_path(pitch)
        end

        it { is_expected.to redirect_to pitches_path }
      end
    end

    describe 'get /pitch/:id/presenter' do
      before { get pitch_step_path(pitch, :presenter) }
      it { is_expected.to be_successful }
    end

    describe 'get /pitch/:id/idea' do
      before do
        post new_pitch_path, params: { pitch: pitch_params }
        get pitch_step_path(pitch, :idea)
      end

      let(:pitch_params) do
        {
          presenter: {
            name: participant.name,
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep',
            availability: 'yes'
          },
          code_of_conduct: '1'
        }
      end

      let(:pitch) { participant.pitches.last }

      it { is_expected.to be_successful }
    end

    describe 'put /pitch/:id/presenter' do
      before { put pitch_step_path(pitch, :presenter), params: params }
      let(:params) do
        {
          pitch: { presenter: { name: 'Updated' } }
        }
      end

      it { is_expected.to be_successful }

      it 'updates the pitch' do
        expect(pitch.reload.info.presenter.name).to eq 'Updated'
      end
    end

    describe 'put /pitch/:id/idea' do
      before do
        pitch.info.presenter = {
          name: participant.name,
          city: 'Wellington',
          country_code: 'NZ',
          bio: 'clear eyes, full heart, can’t sleep',
          availability: 'yes'
        }
        pitch.info.code_of_conduct_accepted = true
        pitch.save!
        put pitch_step_path(pitch, :idea), params: params
      end

      let(:params) do
        {
          pitch: { activity: { name: 'Updated' } }
        }
      end

      it { is_expected.to be_successful }

      it 'updates the pitch' do
        expect(pitch.reload.info.activity.name).to eq 'Updated'
      end
    end

    describe 'delete /pitches/:id' do
      before { pitch }

      it 'deletes the pitch' do
        expect { delete pitch_path(pitch) }.to change(Pitch, :count).by(-1)
      end

      it 'redirects to the pitches page' do
        delete pitch_path(pitch)
        expect(response).to redirect_to pitches_path
      end

      context 'when the pitch has been submitted' do
        it 'does not delete the pitch' do
          pitch.submitted!
          expect { delete pitch_path(pitch) }
            .to raise_error ActiveRecord::RecordNotFound
        end
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
          presenter: {
            name: 'Test participant',
            email: 'test@example.com',
            password: 'p4$$w0rd',
            password_confirmation: 'p4$$w0rd',
            city: 'Wellington',
            country_code: 'NZ',
            bio: 'clear eyes, full heart, can’t sleep',
            availability: 'yes'
          },
          code_of_conduct: '1'
        }
      end
      let(:pitch) { Pitch.last }
      let(:next_step) { pitch_step_path(pitch, :idea) }

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
