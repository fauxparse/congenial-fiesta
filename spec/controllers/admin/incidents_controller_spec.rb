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

  describe 'POST /admin/:year/incidents/:id/close' do
    let(:incident) { create(:incident, festival: festival) }

    it 'closes the incident' do
      post close_admin_incident_path(festival, incident)
      expect(response).to redirect_to admin_incidents_path(festival)
      expect(incident.reload).to be_closed
    end
  end

  describe 'POST /admin/:year/incidents/:id/reopen' do
    let(:incident) { create(:incident, festival: festival).tap(&:closed!) }

    it 'reopens the incident' do
      post reopen_admin_incident_path(festival, incident)
      expect(response).to redirect_to admin_incident_path(festival, incident)
      expect(incident.reload).to be_open
    end
  end

  describe 'POST /admin/:year/incidents/:id/comments' do
    let(:incident) { create(:incident, festival: festival).tap(&:closed!) }
    let(:params) { { comment: { text: 'comment' } } }

    def do_post
      post comments_admin_incident_path(festival, incident), params: params
    end

    it 'adds a comment' do
      expect { do_post }.to change(Comment, :count).by(1)
      expect(response).to redirect_to admin_incident_path(festival, incident)
    end
  end
end
