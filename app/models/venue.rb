# frozen_string_literal: true

class Venue < ApplicationRecord
  acts_as_mappable(
    default_units: :kms,
    lat_column_name: :latitude,
    lng_column_name: :longitude
  )

  validates :latitude, :longitude, presence: true, numericality: true
end
