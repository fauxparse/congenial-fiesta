# frozen_string_literal: true

class PitchForm
  class Step
    class Finish < Step
      validates :finished, presence: true

      def finished
        false
      end
    end
  end
end
