# frozen_string_literal: true

class Pitch
  class ActivityInfo < Hashie::Dash
    include Hashie::Extensions::Dash::Coercion

    property :type
    property :name
    property :workshop_description
    property :comments
    property :previously_taught

    def initialize(*args)
      super
      self.type = type
    end

    def type
      self.class.name.demodulize.underscore.sub(/_info$/, '')
    end
  end
end
