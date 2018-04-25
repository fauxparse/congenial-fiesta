# frozen_string_literal: true

class Pitch
  class ExperimentalPerformanceInfo < PerformanceInfo
    property :experience

    validates :experience, presence: true
  end
end
