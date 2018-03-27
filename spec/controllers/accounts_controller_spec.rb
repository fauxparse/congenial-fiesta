# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AccountsController, type: :request do
  subject { response }

  describe 'get /signup' do
    context 'when not logged in' do
      before { get signup_path }
      it { is_expected.to be_successful }
    end

    context 'when logged in' do
      before do
        log_in_as create(:participant, :with_password)
        get signup_path
      end

      it { is_expected.to redirect_to root_path }
    end
  end

  describe 'post /signup' do
    let(:signup_request) do
      post signup_path, params: { participant: attributes }
    end

    context 'with valid attributes' do
      let(:attributes) do
        {
          name: 'Test Participant',
          email: 'test@example.com',
          password: 'p4$$w0rd',
          password_confirmation: 'p4$$w0rd'
        }
      end

      it 'creates a participant' do
        expect { signup_request }.to change(Participant, :count).by(1)
      end

      it 'creates an identity' do
        expect { signup_request }.to change(Identity::Password, :count).by(1)
      end

      it 'logs the new participant in' do
        signup_request
        expect(session[:participant]).to eq Participant.last.id
      end

      it 'redirects to the homepage' do
        signup_request
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid attributes' do
      let(:attributes) do
        {
          name: 'Test Participant',
          email: 'test@example.com',
          password: 'p4$$w0rd',
          password_confirmation: 'bad'
        }
      end

      it 'does not create a participant' do
        expect { signup_request }.not_to change(Participant, :count)
      end

      it 'does not create an identity' do
        expect { signup_request }.not_to change(Identity::Password, :count)
      end

      it 'stays logged out' do
        signup_request
        expect(session[:participant]).to be_nil
      end

      it 'renders the signup form' do
        signup_request
        expect(response).not_to be_redirect
      end
    end
  end
end
