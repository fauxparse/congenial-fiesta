# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LatLngSerializer, type: :serializer do
  subject(:serializer) { LatLngSerializer.new(Venue.origin) }
  let(:json) { serializer.call }

  it 'represents the object' do
    expect(json).to eq(
      latitude: Venue.origin.lat,
      longitude: Venue.origin.lng
    )
  end
end
