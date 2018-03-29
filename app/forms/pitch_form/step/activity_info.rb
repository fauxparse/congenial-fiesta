# frozen_string_literal: true

class PitchForm
  class Step
    class ActivityInfo < Step
      validates :name, presence: true

      def name
        nil
      end
    end
  end
end
