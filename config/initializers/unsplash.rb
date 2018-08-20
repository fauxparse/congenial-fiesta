# frozen_string_literal: true

Unsplash.configure do |config|
  credentials = Rails.application.credentials.unsplash
  config.application_id = credentials[:access_key]
  config.application_secret = credentials[:secret_key]
end
