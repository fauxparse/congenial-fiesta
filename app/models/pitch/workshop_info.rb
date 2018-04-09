# frozen_string_literal: true

class Pitch
  class WorkshopInfo < ActivityInfo
    property :levels,
      default: -> { Set.new },
      coerce: ->(levels) { Set.new((levels || {}).reject(&:blank?)) }
    property :prerequisites
    property :number_of_participants,
      default: 16,
      coerce: ->(value) { value.to_i }
  end
end
