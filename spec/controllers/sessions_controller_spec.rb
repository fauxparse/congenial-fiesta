# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  subject { response }
  let(:participant) { create(:participant, :with_password) }
  let(:email) { participant.email }
  let(:password) { 'p4$$w0rd' }
  let(:credentials) { { email: email, password: password } }

  describe 'get /login' do
    context 'when not logged in' do
      before { get login_path }
      it { is_expected.to be_successful }
    end

    context 'when logged in' do
      before do
        log_in_as create(:participant, :with_password)
        get login_path
      end

      it { is_expected.to redirect_to root_path }
    end

    context 'and redirect' do
      before do
        get login_path, params: { redirect: path }
        post login_path, params: { login: credentials }
      end

      context 'to a valid path' do
        let(:path) { code_of_conduct_path }

        it 'redirects after login' do
          expect(response).to redirect_to path
        end
      end

      context 'to a dodgy path' do
        let(:path) { 'http://suspicious.ru' }

        it 'does not redirect' do
          expect(response).not_to redirect_to path
        end
      end

      context 'to a bad path' do
        let(:path) { '/stuff/is/broken' }

        it 'does not redirect' do
          expect(response).not_to redirect_to path
        end
      end
    end
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

  describe 'post /auth/:provider/callback' do
    before do
      OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(oauth_info)

      Rails.application.env_config['omniauth.auth'] =
        OmniAuth.config.mock_auth[provider]
      post "/auth/#{provider}/callback"
    end

    let(:oauth_info) do
      {
        'provider' => provider.to_s,
        'uid' => uid,
        'info' => {
          'name' => name,
          'email' => email
        }
      }
    end

    let(:provider) { :twitter }
    let(:uid) { SecureRandom.uuid }
    let(:name) { participant.name }
    let(:email) { participant.email }

    context 'for a previously-authorised participant' do
      let(:participant) { create(:participant, :with_oauth) }
      let(:uid) { participant.identities.first.uid }

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end

      it 'logs in the user' do
        expect(session[:participant]).to eq participant.id
      end

      context 'who is already logged in' do
        let(:provider) { :google }
        let(:email) { 'test@gmail.com' }

        before { log_in_as(participant) }

        it 'logs in the existing user' do
          expect(session[:participant]).to eq participant.id
        end

        it 'does not change the participant’s email' do
          expect(participant.reload.email).not_to eq email
        end
      end
    end

    context 'for a new participant' do
      let(:participant) { build(:participant) }

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end

      it 'creates the user' do
        expect(Participant.with_email(email)).to exist
      end

      it 'logs in the user' do
        expect(session[:participant]).to be_present
      end
    end

    context 'for an existing participant with a new auth method' do
      let(:participant) { create(:participant, :with_password) }

      it 'redirects to the home page' do
        expect(response).to redirect_to root_path
      end

      it 'creates the identity' do
        expect(participant.identities.count).to eq 2
      end

      it 'logs in the user' do
        expect(session[:participant]).to eq participant.id
      end
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
