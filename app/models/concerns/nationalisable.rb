# frozen_string_literal: true

module Nationalisable
  extend ActiveSupport::Concern

  def country
    return nil if country_code.blank?
    country = ISO3166::Country[country_code]
    country.translations[I18n.locale.to_s] || country.name
  end

  def country=(country_name)
    country = ISO3166::Country.find_country_by_name(country_name.to_s)
    self.country_code = country&.alpha2
  end
end
