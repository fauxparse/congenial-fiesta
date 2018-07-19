# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VenuesSerializer, type: :serializer do
  subject(:serializer) do
    VenuesSerializer.new(venues: [venue], origin: Venue.origin)
  end
  let(:venue) { create(:venue) }
  let(:json) { serializer.call }

  it 'represents the venues' do
    expect(json).to match(
      venues: a_collection_containing_exactly({
        id: venue.id,
        name: venue.name,
        address: venue.address,
        latitude: venue.latitude,
        longitude: venue.longitude
      }),
      origin: {
        latitude: Venue.origin.latitude,
        longitude: Venue.origin.longitude
      }
    )
  end
end
