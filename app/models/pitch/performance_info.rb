# frozen_string_literal: true

class Pitch
  class PerformanceInfo < ActivityInfo
    property :show_description
    property :cast_size,
      default: 6,
      coerce: ->(value) { value.to_i }
    property :previously_performed
    property :technical_requirements

    validates :show_description, :cast_size, presence: true
    validates :cast_size,
      numericality: { greater_than: 0, less_than_or_equal_to: 30 }
  end
end
