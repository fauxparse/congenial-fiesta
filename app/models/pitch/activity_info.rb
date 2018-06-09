# frozen_string_literal: true

class Pitch
  class ActivityInfo < Hashie::Dash
    include Hashie::Extensions::Dash::Coercion
    include ActiveModel::Validations

    TYPES = %w[
      standalone_workshop
      directed_performance
      experimental_performance
    ].freeze

    property :type
    property :name
    property :workshop_description
    property :comments
    property :previously_taught

    validates :type, :name, :workshop_description, presence: true

    def initialize(*args)
      super
      self.type = type
    end

    def type
      self.class.name.demodulize.underscore.sub(/_info$/, '')
    end
  end
end
