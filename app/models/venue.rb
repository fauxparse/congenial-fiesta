# frozen_string_literal: true

class Venue < ApplicationRecord
  acts_as_mappable(
    default_units: :kms,
    lat_column_name: :latitude,
    lng_column_name: :longitude
  )

  validates :latitude, :longitude, presence: true, numericality: true

  # BATS, home to us all
  def self.origin
    @origin ||= Geokit::LatLng.new(-41.2935391, 174.784505).freeze
  end
end
