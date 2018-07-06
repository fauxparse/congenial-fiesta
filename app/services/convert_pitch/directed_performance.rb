# frozen_string_literal: true

class ConvertPitch
  class DirectedPerformance < Base
    def create_activities
      [workshop, show, *super]
    end
  end
end
