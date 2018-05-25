# frozen_string_literal: true

class QueryParameters < Hashie::Dash
  include Hashie::Extensions::IndifferentAccess

  def initialize(options = {})
    super(sanitize(options))
  end

  private

  def sanitize(options)
    if options.respond_to?(:permit)
      options.permit(*self.class.properties)
    else
      options
    end
  end
end
