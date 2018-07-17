# frozen_string_literal: true

class VenuesSerializer < Primalize::Many
  attributes(
    origin: LatLngSerializer,
    venues: enumerable(VenueSerializer)
  )
end
