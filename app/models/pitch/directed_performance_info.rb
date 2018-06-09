# frozen_string_literal: true

class Pitch
  class DirectedPerformanceInfo < PerformanceInfo
    validates :workshop_description, presence: true
  end
end
