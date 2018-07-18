# frozen_string_literal: true

class LatLngSerializer < Primalize::Single
  attributes(
    latitude: float,
    longitude: float
  )

  def latitude
    object.lat
  end

  def longitude
    object.lng
  end
end
