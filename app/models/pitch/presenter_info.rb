# frozen_string_literal: true

class Pitch
  class PresenterInfo < Hashie::Dash
    include Nationalisable

    property :name
    property :city
    property :country_code, default: 'NZ'
    property :company
    property :presented_before
    property :bio
    property :availability
  end
end
