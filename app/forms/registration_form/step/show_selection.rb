# frozen_string_literal: true

class RegistrationForm
  class Step
    class ShowSelection < Step
      include ActivityAssignment

      permit shows: {}

      validates :show_preferences_saved_at, presence: true

      delegate :show_preferences_saved_at, to: :registration

      def to_param
        'shows'
      end

      def activities
        @activities ||=
          ActivitySelector.new(registration, scope: Show, grouped: false)
      end

      def assign_attributes(attributes)
        super(attributes.reverse_merge(shows: {}))
      end

      def update(attributes = {})
        Preference.acts_as_list_no_update do
          super
        end
      end

      private

      def shows=(preferences)
        update_preferences(preferences.transform_keys(&:to_i), type: Show)
        registration.show_preferences_saved_at ||= Time.zone.now
      end
    end
  end
end
