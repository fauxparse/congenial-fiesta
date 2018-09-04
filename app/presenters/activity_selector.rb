# frozen_string_literal: true

class ActivitySelector
  include Enumerable

  attr_reader :registration, :max, :max_per_slot

  delegate :festival, to: :registration

  def initialize(registration,
    scope: Activity, grouped: true, max: nil, max_per_slot: 1)
    @registration = registration
    @scope = scope
    @grouped = grouped
    @max = max
    @max_per_slot = max_per_slot
  end

  def each_day(&_block)
    return enum_for(:each_day) unless block_given?

    (festival.start_date..festival.end_date).map do |date|
      scheduled = activities.select { |a| a.starts_at.to_date == date }
      yield date, Timeslot.from(scheduled, grouped: grouped?) if scheduled.any?
    end
  end

  def to_partial_path
    '/registrations/activity_selector'
  end

  def grouped?
    @grouped.to_b
  end

  def type
    @scope.name.pluralize.underscore
  end

  delegate :each, to: :activities

  private

  def scope
    @scope
      .includes(:schedules, presenters: :participant)
      .references(:schedules)
      .merge(Schedule.not_freebie)
      .merge(Schedule.sorted)
      .where('activities.festival_id = ?', festival.id)
  end

  def schedules
    @schedules ||= scope.all.flat_map(&:schedules)
  end

  def activities
    @activities ||= schedules.map(&method(:scheduled))
  end

  def scheduled(activity)
    ScheduledActivity.new(
      activity,
      registration: registration,
      available: available?(activity),
      selection: selection_for(activity)
    )
  end

  def available?(activity)
    !presenting_opposite?(activity) && places_left?(activity)
  end

  def places_left?(activity)
    !activity.limited? ||
      max_per_slot.nil? ||
      count(activity) < activity.maximum
  end

  def presenting_opposite?(activity)
    (schedules - [activity]).any? do |s|
      s.slot == activity.slot && presenting?(s.activity)
    end
  end

  def presenting?(activity)
    activity.presenters.any? { |p| p.participant == registration.participant }
  end

  def selection_for(activity)
    registration
      .selections
      .detect { |s| s.schedule_id == activity.id && !s.marked_for_destruction? }
  end

  def registrations
    @registrations ||= RegistrationStage.new(festival)
  end

  def count(schedule)
    @counts ||=
      festival
      .schedules
      .joins(selections: :registration)
      .merge(Selection.included_in_limit)
      .where('registrations.participant_id <> ?', registration.participant_id)
      .group('schedules.id')
      .count('selections.id')
    @counts[schedule.id] || 0
  end

  class Timeslot
    attr_reader :activities

    def self.from(activities, grouped: true)
      activities
        .group_by { |activity| grouped ? activity.starts_at : true }
        .to_a
        .map { |_, group| new(group) }
    end

    def initialize(activities)
      @activities = activities.sort
    end

    def selected?
      activities.any?(&:selected?)
    end

    delegate :starts_at, :ends_at, to: :first_activity, allow_nil: true

    private

    def first_activity
      activities.first
    end
  end
end
