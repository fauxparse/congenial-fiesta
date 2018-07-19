# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VenueSerializer, type: :serializer do
  subject(:serializer) { VenueSerializer.new(venue) }
  let(:venue) { create(:venue) }
  let(:json) { serializer.call }

  it 'represents the venue' do
    expect(json).to eq(
      id: venue.id,
      name: venue.name,
      address: venue.address,
      latitude: venue.latitude,
      longitude: venue.longitude
    )
  end
end
