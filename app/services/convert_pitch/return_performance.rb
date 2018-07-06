# frozen_string_literal: true

class ConvertPitch
  class ReturnPerformance < Base
    def create_activities
      [show, *super]
    end
  end
end
