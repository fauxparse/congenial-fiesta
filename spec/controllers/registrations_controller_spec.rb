# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  subject { response }
  let!(:festival) { create(:festival) }

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
      let(:registration_params) do
        {
          name: 'Kiki Hohnen',
          email: 'kiki@example.com',
          password: 'p4$$w0rd',
          password_confirmation: 'p4$$w0rd',
          city: 'Amsterdam',
          country_code: 'nl'
        }
      end

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
  end
end
