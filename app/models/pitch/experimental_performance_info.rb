# frozen_string_literal: true

class Pitch
  class ExperimentalPerformanceInfo < PerformanceInfo
    property :experience

    validates :experience, :workshop_description, presence: true
  end
end
