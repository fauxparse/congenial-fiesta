# frozen_string_literal: true

module OmniAuth
  def self.registered_providers
    @registered_providers ||= []
  end

  class Builder
    def provider_with_memoization(name, *args, &block)
      options = args.extract_options!
      OmniAuth.registered_providers << (options[:name] || name)
      provider_without_memoization(name, *args, options, &block)
    end

    alias provider_without_memoization provider
    alias provider provider_with_memoization
  end
end

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_KEY'], ENV['GOOGLE_SECRET'],
    name: :google
  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET']
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :developer unless Rails.env.production?
end

OmniAuth.config.logger = Rails.logger
OmniAuth.config.test_mode = Rails.env.test?
