# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
    name: :google
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.test_mode = Rails.env.test?
