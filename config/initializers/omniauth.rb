# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.test_mode = Rails.env.test?
