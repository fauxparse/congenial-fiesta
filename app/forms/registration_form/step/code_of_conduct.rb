# frozen_string_literal: true

class RegistrationForm
  class Step
    class CodeOfConduct < Step
      permit :code_of_conduct_accepted

      validates :code_of_conduct_accepted, acceptance: true

      def code_of_conduct_accepted
        registration.code_of_conduct_accepted_at.present?
      end

      alias code_of_conduct_accepted? code_of_conduct_accepted

      def code_of_conduct_accepted=(value)
        registration.code_of_conduct_accepted_at =
          value ? Time.zone.now : nil
      end
    end
  end
end
