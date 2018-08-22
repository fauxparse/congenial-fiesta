# frozen_string_literal: true

class RegistrationForm
  class Step
    class WorkshopSelection < Step
      permit workshops: {}

      validates :workshop_preferences_saved_at, presence: true

      delegate :workshop_preferences_saved_at, to: :registration

      def to_param
        'workshops'
      end

      def activities
        @activities ||= ActivitySelector.new(registration, scope: Workshop)
      end

      def update(attributes = {})
        Preference.acts_as_list_no_update do
          super(attributes.reverse_merge(workshops: {}))
        end
      end

      private

      def workshops=(preferences)
        update_preferences(preferences.transform_keys(&:to_i))
        registration.workshop_preferences_saved_at ||= Time.zone.now
      end

      def update_preferences(preferences)
        remove_old_preferences(preferences)
        add_new_preferences(preferences)
      end

      def remove_old_preferences(preferences)
        registration
          .preferences
          .reject { |p| preferences.include?(p.schedule_id) }
          .map(&:mark_for_destruction)
      end

      def add_new_preferences(by_id)
        by_id.each do |schedule_id, position|
          find_or_build_preference(schedule_id).position = position
        end
      end

      def find_or_build_preference(schedule_id)
        registration.preferences.detect { |p| p.schedule_id == schedule_id } ||
          registration.preferences.build(schedule_id: schedule_id)
      end
    end
  end
end
