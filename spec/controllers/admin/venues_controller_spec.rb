# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::VenuesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/venues' do
    it 'returns http success' do
      get admin_venues_path(festival)
      expect(response).to be_successful
    end
  end

  describe 'POST /admin/:year/venues' do
    let(:venue_attributes) do
      {
        name: 'BATS Theatre',
        address: '1 Kent Terrace',
        latitude: Venue.origin.lat,
        longitude: Venue.origin.lng
      }
    end

    def do_create
      post admin_venues_path(festival, format: :json),
        params: { venue: venue_attributes }
    end

    it 'creates a venue' do
      expect { do_create }.to change(Venue, :count).by 1
      expect(response).to be_successful
    end
  end

  describe 'PUT /admin/:year/:venues/:id' do
    let!(:venue) { create(:venue) }

    def do_update
      put admin_venue_path(festival, venue, format: :json),
        params: { venue: { name: 'New name' } }
    end

    it 'updates the venue' do
      expect { do_update }.to change { venue.reload.name }
      expect(response).to be_successful
    end
  end

  describe 'DELETE /admin/:year/:venues/:id' do
    let!(:venue) { create(:venue) }

    it 'deletes the venue' do
      expect { delete admin_venue_path(festival, venue, format: :json) }
        .to change(Venue, :count).by(-1)
      expect(response).to be_successful
    end
  end
end
