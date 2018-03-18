# frozen_string_literal: true

require 'simplecov'

# save to CircleCI's artifacts directory if we're on CircleCI
ENV['CIRCLE_ARTIFACTS'] &&
  SimpleCov.coverage_dir(File.join(ENV['CIRCLE_ARTIFACTS'], 'coverage'))

SimpleCov.start('rails') do
  add_filter do |source_file|
    source_file.lines.count < 7
  end
end
