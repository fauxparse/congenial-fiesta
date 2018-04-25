# frozen_string_literal: true

class PitchForm
  class Step
    class Finish < Step
      validates :finished, presence: true

      def finished
        pitch.submitted?
      end

      def apply!
        pitch.submitted!
      end
    end
  end
end
