# frozen_string_literal: true

class Pitch
  class ExperimentalPerformanceInfo < PerformanceInfo
    property :experience

    validates :experience, :workshop_description, presence: true

    def levels
      Set.new(%w(advanced))
    end
  end
end
