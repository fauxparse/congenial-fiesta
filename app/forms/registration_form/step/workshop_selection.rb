# frozen_string_literal: true

class RegistrationForm
  class Step
    class WorkshopSelection < Step
      include ActivityAssignment

      permit workshops: {}

      validates :workshops_saved_at, presence: true

      delegate :workshops_saved_at, to: :registration

      def to_param
        'workshops'
      end

      def activities
        @activities ||=
          ActivitySelector.new(
            registration,
            scope: Workshop,
            max_per_slot: registrations.earlybird? ? nil : 1
          )
      end

      def assign_attributes(attributes)
        super(attributes.reverse_merge(workshops: {}))
      end

      def update(attributes = {})
        Selection.acts_as_list_no_update do
          super
        end
      end

      def registrations
        @registrations ||= RegistrationStage.new(registration.festival)
      end

      private

      def workshops=(selections)
        update_selections(selections.transform_keys(&:to_i), type: Workshop)
        registration.workshops_saved_at ||= Time.zone.now
      end
    end
  end
end
