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
    festival
      .schedules
      .not_freebie
      .includes(activity: { presenters: :participant })
      .references(:activity)
      .sorted
      .merge(@scope.all)
  end

  def schedules
    @schedules ||= scope.all
  end

  def activities
    @activities ||=
      schedules
      .zip(photos)
      .map { |activity, photo| scheduled(activity, photo: photo) }
  end

  def scheduled(activity, photo: nil)
    ScheduledActivity.new(
      activity,
      registration: registration,
      photo: photo,
      available: available?(activity)
    )
  end

  def available?(activity)
    schedules.none? { |s| s.slot == activity.slot && presenting?(s.activity) }
  end

  def presenting?(activity)
    activity.presenters.any? { |p| p.participant == registration.participant }
  end

  def photos
    @photos ||=
      (1..(scope.count / 30.0).ceil)
      .flat_map { |page| Unsplash::Photo.search('dinosaur', page, 30) }
      .map { |photo| photo.urls[:small] }
  end

  def registrations
    @registrations ||= RegistrationStage.new(festival)
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
