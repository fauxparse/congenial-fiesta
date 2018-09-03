# frozen_string_literal: true

require 'simplecov'

SimpleCov.start('rails') do
  add_filter do |source_file|
    source_file.lines.count < 7
  end

  add_group 'Forms', 'app/forms'
  add_group 'Policies', 'app/policies'
  add_group 'Presenters', 'app/presenters'
  add_group 'Queries', 'app/queries'
  add_group 'Serializers', 'app/serializers'
  add_group 'Services', 'app/services'
  add_group 'Validators', 'app/validators'
end
