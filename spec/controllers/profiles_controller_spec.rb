# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProfilesController, type: :request do
  subject { response }

  describe 'get /profile' do
    context 'when logged in' do
      let(:participant) { create(:participant, :with_password) }

      before do
        log_in_as(participant)
        get profile_path
      end

      it { is_expected.to be_successful }
    end

    context 'when not logged in' do
      before { get profile_path }

      it { is_expected.to redirect_to login_path }

      it 'remembers where to go after login' do
        expect(session[:redirect]).to eq profile_path
      end
    end
  end

  describe 'patch /profile' do
    let(:participant) { create(:participant, :with_password) }
    let(:attributes) { { name: 'New name', email: 'new@example.com' } }

    before do
      log_in_as(participant)
      patch profile_path, params: { participant: attributes }
    end

    it { is_expected.to be_successful }

    it 'updates the participant’s details' do
      expect(participant.reload.email).to eq attributes[:email]
    end
  end

  describe 'get /connect/twitter' do
    before do
      log_in_as(participant)
      get connect_profile_path(:twitter)
    end

    context 'for a participant without a connected Twitter account' do
      let(:participant) { create(:participant, :with_password) }
      it { is_expected.to redirect_to '/auth/twitter' }
    end

    context 'for a participant with a connected Twitter account' do
      let(:participant) { create(:participant, :with_password, :with_oauth) }
      it { is_expected.to redirect_to profile_path }
    end
  end

  describe 'delete /connect/twitter' do
    before { log_in_as(participant) }

    context 'for a participant with a connected Twitter account' do
      let(:participant) { create(:participant, :with_oauth) }

      it 'does not delete the identity' do
        expect { delete connect_profile_path(:twitter) }
          .not_to change(Identity, :count)
        expect(response).to redirect_to profile_path
      end
    end

    context 'for a participant with a password and a connected Twitter' do
      let(:participant) { create(:participant, :with_password, :with_oauth) }

      it 'deletes the identity' do
        expect { delete connect_profile_path(:twitter) }
          .to change(Identity, :count)
          .by(-1)
        expect(response).to redirect_to profile_path
      end
    end
  end
end
