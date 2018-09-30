# frozen_string_literal: true

class RegistrationForm
  class Step
    class ShowSelection < Step
      include ActivityAssignment

      permit shows: {}, waitlist: []
      permit :attending_gala

      validates :shows_saved_at, presence: true

      delegate :shows_saved_at, to: :registration

      def to_param
        'shows'
      end

      def activities
        @activities ||=
          ActivitySelector.new(
            registration,
            scope: Show,
            grouped: false,
            max: maximum
          )
      end

      def selections
        registration.selections.included_in_limit.merge(Show.all)
      end

      def maximum
        [workshops_count, 5].min
      end

      def assign_attributes(attributes)
        super(attributes.reverse_merge(shows: {}))
      end

      def update(attributes = {})
        Selection.acts_as_list_no_update do
          super
        end
      end

      def gala
        @gala ||=
          registration
          .festival
          .schedules
          .freebie
          .includes(:activity)
          .merge(Show.all)
          .first
      end

      def attending_gala
        !registration.shows_saved? ||
          (gala_selection && !gala_selection.marked_for_destruction?)
      end

      alias attending_gala? attending_gala

      def attending_gala=(value)
        if value.to_b
          registration.selections.build(schedule: gala) unless attending_gala?
        else
          gala_selection&.mark_for_destruction
        end
      end

      private

      def shows=(selections)
        update_selections(selections.transform_keys(&:to_i), type: Show)
        registration.shows_saved_at ||= Time.zone.now
      end

      def waitlist=(ids)
        update_waitlists(ids.reject(&:blank?).map(&:to_i), type: Show)
      end

      def workshops_count
        @workshops_count ||=
          registration
          .selections
          .joins(schedule: :activity)
          .merge(Workshop.all)
          .pluck(:slot)
          .uniq
          .size
      end

      def gala_selection
        registration.selections.detect { |s| s.schedule_id == gala.id }
      end
    end
  end
end
