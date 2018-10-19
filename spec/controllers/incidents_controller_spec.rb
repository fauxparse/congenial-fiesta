# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncidentsController, type: :request do
  let!(:festival) { create(:festival) }

  describe 'GET /code_of_conduct/incidents/new' do
    it 'is successful' do
      get new_incident_path
      expect(response).to be_successful
    end
  end

  describe 'POST /code_of_conduct/incidents' do
    def do_post
      post incidents_path, params: { incident: params }
    end

    context 'with good params' do
      let(:params) { attributes_for(:incident, festival: festival) }

      it 'is successful' do
        do_post
        expect(response).to be_successful
      end

      it 'creates an incident' do
        expect { do_post }.to change(Incident, :count).by(1)
      end

      context 'when logged in' do
        let(:participant) { create(:participant, :with_password) }

        before { log_in_as(participant) }

        it 'logs the incident against the participant' do
          do_post
          expect(Incident.last.participant).to eq participant
        end
      end
    end

    context 'with bad params' do
      let(:params) { { anonymous: true } }

      it 'does not create an incident' do
        expect { do_post }.not_to change(Incident, :count)
      end
    end
  end
end
