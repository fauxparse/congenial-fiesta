# frozen_string_literal: true

module Admin
  class RegistrationForm
    attr_reader :registration

    def initialize(registration)
      @registration = registration
    end

    def schedules(type: Activity)
      activities
        .select { |a| a.is_a?(type) }
        .flat_map(&:schedules)
        .map { |s| scheduled(s) }
        .group_by(&:starts_at)
        .to_a
        .sort_by(&:first)
    end

    def update(params)
      update_activities(params[:activities]) if params.key?(:activities)
      registration.save!
      # registration.selections.each do |s|
      #   Rails.logger.info(
      #     s.changes.merge(deleted: s.marked_for_destruction?).inspect
      #   )
      # end
    end

    private

    def activities
      @activities ||=
        registration
          .festival
          .activities
          .includes(:schedules, presenters: :participant)
          .all
    end

    def scheduled(schedule)
      ScheduledActivity.new(
        schedule,
        registration: registration,
        available: available?(schedule),
        selection: selection(schedule)
      )
    end

    def available?(schedule)
      selection(schedule) || schedule.available?
    end

    def selection(schedule, build: false)
      registration.selections.detect { |s| s.schedule_id == schedule.id } ||
        (build ? registration.selections.build(schedule: schedule) : nil)
    end

    def update_activities(activities)
      activities.transform_keys(&:to_i).each do |id, state|
        schedule = Schedule.find(id)
        case state
        when 'allocated' then allocate(schedule)
        when 'unselected' then deselect(schedule)
        when 'waitlisted' then waitlist(schedule)
        else unwaitlist(schedule)
        end
      end
    end

    def allocate(schedule)
      unwaitlist(schedule)
      sel = selection(schedule, build: true)
      sel.state = :allocated
      others_in_slot(schedule)
        .select(&:allocated?)
        .each(&:mark_for_destruction)
    end

    def deselect(schedule)
      selection(schedule)&.mark_for_destruction
    end

    def waitlist_for(schedule)
      registration
        .waitlists
        .reject(&:marked_for_destruction?)
        .detect { |w| w.schedule == schedule }
    end

    def waitlist(schedule)
      waitlist_for(schedule) ||
        registration.waitlists.build(schedule: schedule)
    end

    def unwaitlist(schedule)
      waitlist_for(schedule)&.mark_for_destruction
    end

    def others_in_slot(schedule)
      registration.selections.select do |selection|
        selection.slot == schedule.slot && selection.schedule.id != schedule.id
      end
    end
  end
end
