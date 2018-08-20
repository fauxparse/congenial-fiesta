# frozen_string_literal: true

class RegistrationForm
  class Step
    class WorkshopSelection < Step
      def to_param
        'workshops'
      end

      def complete?
        false
      end

      def activities
        @activities ||= ActivitySelector.new(registration, scope: Workshop)
      end
    end
  end
end
