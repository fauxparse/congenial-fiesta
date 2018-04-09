# frozen_string_literal: true

class Pitch
  class PerformanceInfo < ActivityInfo
    property :show_description
    property :cast_size,
      default: 6,
      coerce: ->(value) { value.to_i }
    property :previously_performed
    property :technical_requirements
  end
end
