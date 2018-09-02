# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.0'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'mini_racer', platforms: :ruby

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

gem 'acts-as-taggable-on', '~> 6.0'
gem 'acts_as_list', github: 'swanandp/acts_as_list'
gem 'auto_strip_attributes', '~> 2.3'
gem 'autoprefixer-rails'
gem 'aws-sdk-s3', require: false
gem 'bitters', github: 'thoughtbot/bitters'
gem 'bourbon', github: 'thoughtbot/bourbon'
gem 'colorize'
gem 'country_select', github: 'stefanpenner/country_select'
gem 'cry'
gem 'css-class-string'
gem 'figaro'
gem 'geokit'
gem 'geokit-rails'
gem 'haml-rails'
gem 'hashid-rails'
gem 'hashie'
gem 'high_voltage'
gem 'inline_svg'
gem 'letter_opener'
gem 'letter_opener_web'
gem 'mini_magick'
gem 'money'
gem 'money-rails'
gem 'neat', github: 'thoughtbot/neat'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'omniauth-twitter'
gem 'ordinalize_full'
gem 'premailer-rails'
gem 'primalize'
gem 'pundit'
gem 'redcarpet'
gem 'scavenger'
gem 'sendgrid-ruby'
gem 'stringex'
gem 'unsplash'
gem 'wannabe_bool'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'rspec-rails'
  gem 'rubocop', require: false
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'

  gem 'brakeman', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'email_spec'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'zonebie'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
