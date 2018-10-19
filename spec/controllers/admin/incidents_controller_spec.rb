# frozen_srtring_literal: true

require 'rails_helper'

RSpec.describe Admin::IncidentsController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/incidents' do
    it 'is successful' do
      get admin_incidents_path(festival)
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/:year/incidents/:id' do
    let(:incident) { create(:incident, festival: festival) }

    it 'is successful' do
      get admin_incident_path(festival, incident)
      expect(response).to be_successful
    end
  end
end
