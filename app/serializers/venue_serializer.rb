# frozen_string_literal: true

class VenueSerializer < Primalize::Single
  attributes(
    id: integer,
    name: string,
    address: string,
    latitude: float,
    longitude: float
  )

  def latitude
    object.latitude.to_f
  end

  def longitude
    object.longitude.to_f
  end
end
