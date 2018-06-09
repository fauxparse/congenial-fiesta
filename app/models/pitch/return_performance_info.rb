# frozen_string_literal: true

class Pitch
  class ReturnPerformanceInfo < PerformanceInfo
    property :original_cast

    validates :original_cast, presence: true
  end
end
