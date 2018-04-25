# frozen_string_literal: true

class Pitch
  class WorkshopInfo < ActivityInfo
    property :levels,
      default: -> { Set.new },
      coerce: ->(levels) { Set.new((levels || {}).reject(&:blank?)) }
    property :prerequisites
    property :number_of_participants,
      default: 16,
      coerce: ->(value) { value&.to_i }

    validates :levels, :number_of_participants, presence: true
    validates :number_of_participants,
      numericality: { greater_than: 6, less_than_or_equal_to: 30 }
  end
end
