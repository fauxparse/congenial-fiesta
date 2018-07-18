# frozen_string_literal: true

module MapboxHelper
  def mapbox_api_key
    Rails.application.credentials.dig(:mapbox, :api_key)
  end

  def mapbox_style
    Rails.application.credentials.dig(:mapbox, :style)
  end
end
