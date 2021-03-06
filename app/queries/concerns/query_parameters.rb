# frozen_string_literal: true

class QueryParameters < Hashie::Dash
  include Hashie::Extensions::IndifferentAccess

  def initialize(options = {})
    super(sanitize(options))
  end

  private

  def sanitize(options)
    if options.respond_to?(:permit)
      options.permit(*properties_to_permit)
    else
      options
    end
  end

  def properties_to_permit
    self.class.properties.to_a
  end
end
