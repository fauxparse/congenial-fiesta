# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  subject { response }
  let!(:festival) { create(:festival) }
  let(:registration_params) do
    {
      name: 'Kiki Hohnen',
      email: 'kiki@impro.nl',
      password: 'p4$$w0rd',
      password_confirmation: 'p4$$w0rd',
      city: 'Amsterdam',
      country_code: 'nl'
    }
  end

  describe 'GET /register' do
    before { get registration_path }
    it { is_expected.to be_successful }
  end

  describe 'PUT /register' do
    def do_update
      put registration_step_path(:participant_details),
        params: { registration: registration_params }
    end

    context 'with good parameters' do
      it 'creates a participant' do
        expect { do_update }
          .to change(Participant, :count)
          .by(1)
          .and change(Registration, :count)
          .by(1)
      end
    end

    context 'with bad parameters' do
      let(:registration_params) do
        {
          name: 'Kiki Hohnen',
          email: 'kiki@example.com',
          city: 'Amsterdam',
          country_code: 'nl'
        }
      end

      it 'creates a participant' do
        expect { do_update }
          .to not_change(Participant, :count)
          .and not_change(Registration, :count)
      end
    end

    context 'progressing through the registration process' do
      let(:workshop) { create(:workshop, festival: festival) }
      let!(:schedule) { create(:schedule, activity: workshop) }
      let(:json) { JSON.parse(response.body).deep_symbolize_keys }

      before do
        put registration_step_path(:details),
          params: { registration: registration_params }
        put registration_step_path(:code_of_conduct),
          params: { registration: { code_of_conduct_accepted: true  } }
        put registration_step_path(:workshops),
          params: { registration: { workshops: { schedule.id => 1 } } }
        put registration_step_path(:shows),
          params: { registration: { shows: {} } }
        put registration_step_path(:payment),
          params: { registration: { payment_method: 'internet_banking' } }
      end

      it { is_expected.to redirect_to complete_registration_path }
    end
  end

  describe 'GET /register/complete' do
    before { get complete_registration_path }
    it { is_expected.to redirect_to(registration_path) }
  end

  describe 'POST /register/cart' do
    let(:workshop) { create(:workshop, festival: festival) }
    let!(:schedule) { create(:schedule, activity: workshop) }
    let(:json) { JSON.parse(response.body).deep_symbolize_keys }

    before do
      put registration_step_path(:details),
        params: { registration: registration_params }
      put registration_step_path(:code_of_conduct),
        params: { registration: { code_of_conduct_accepted: true  } }
      post update_cart_path(format: :json),
        params: { registration: { workshops: { schedule.id => 1 } } }
    end

    it 'returns a cart total' do
      expect(json).to include :total
    end
  end

  describe 'GET /register/with/twitter' do
    before { get '/register/with/twitter' }

    it 'redirects to OAuth login' do
      expect(response).to redirect_to '/auth/twitter'
      expect(session[:redirect]).to eq '/register'
    end
  end
end
