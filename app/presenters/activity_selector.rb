# frozen_string_literal: true

class ActivitySelector
  include Enumerable

  attr_reader :registration

  delegate :festival, to: :registration

  def initialize(registration, scope: Activity)
    @registration = registration
    @scope = scope
  end

  def each_day(&_block)
    return enum_for(:each_day) unless block_given?

    (festival.start_date..festival.end_date).map do |date|
      scheduled = activities.select { |a| a.starts_at.to_date == date }
      yield date, Timeslot.from(scheduled) if scheduled.any?
    end
  end

  def to_partial_path
    '/registrations/activity_selector'
  end

  private

  def scope
    festival
      .schedules
      .includes(activity: { presenters: :participant })
      .references(:activity)
      .sorted
      .merge(@scope.all)
  end

  def activities
    @activities ||=
      scope
      .all
      .zip(photos)
      .map { |activity, photo| scheduled(activity, photo: photo) }
  end

  def scheduled(activity, photo: nil)
    ScheduledActivity.new(
      activity,
      registration: registration,
      photo: photo
    )
  end

  def photos
    @photos ||=
      (1..(scope.count / 30.0).ceil)
      .flat_map { |page| Unsplash::Photo.search('dinosaur', page, 30) }
      .map { |photo| photo.urls[:small] }
  end

  class Timeslot
    attr_reader :activities

    def self.from(activities)
      activities
        .group_by(&:starts_at)
        .to_a
        .map { |_, group| new(group) }
    end

    def initialize(activities)
      @activities = activities.sort
    end

    delegate :starts_at, :ends_at, to: :first_activity, allow_nil: true

    private

    def first_activity
      activities.first
    end
  end
end
