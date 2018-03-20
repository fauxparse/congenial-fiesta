# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  subject { response }
  let(:participant) { create(:participant, :with_password) }
  let(:email) { participant.email }
  let(:password) { 'p4$$w0rd' }
  let(:credentials) { { email: email, password: password } }

  describe 'get /login' do
    before { get login_path }
    it { is_expected.to be_successful }
  end

  describe 'post /login' do
    before { post login_path, params: { login: credentials } }

    context 'with valid credentials' do
      it { is_expected.to redirect_to root_path }

      it 'logs in the participant' do
        expect(session[:participant]).to eq participant.id
      end
    end

    context 'with a bad email address' do
      let(:email) { 'bad' }
      it { is_expected.not_to be_redirect }
    end

    context 'with a bad password' do
      let(:password) { 'bad' }
      it { is_expected.not_to be_redirect }
    end
  end

  describe 'delete /logout' do
    before { post login_path, params: { login: credentials } }

    it 'redirects to the homepage' do
      delete logout_path
      expect(response).to redirect_to root_path
    end

    it 'logs out the participant' do
      expect { delete logout_path }
        .to change { session[:participant] }
        .from(participant.id)
        .to(nil)
    end
  end
end
