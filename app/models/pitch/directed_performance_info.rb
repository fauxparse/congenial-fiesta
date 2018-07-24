# frozen_string_literal: true

class Pitch
  class DirectedPerformanceInfo < PerformanceInfo
    validates :workshop_description, presence: true

    def levels
      Set.new(%w(intermediate advanced))
    end
  end
end
