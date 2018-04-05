# frozen_string_literal: true

class Pitch
  class PresenterInfo < Hashie::Dash
    property :name
    property :city
    property :country_code, default: 'NZ'
    property :company
    property :presented_before
    property :bio

    def country
      country = ISO3166::Country[country_code]
      country.translations[I18n.locale.to_s] || country.name
    end

    def country=(country_name)
      country = ISO3166::Country.find_country_by_name(country_name.to_s)
      self.country_code = country&.alpha2
    end
  end
end
