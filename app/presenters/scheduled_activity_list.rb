# frozen_string_literal: true

class ScheduledActivityList
  attr_reader :festival, :type

  def initialize(festival, type)
    @festival = festival
    @type = type
  end

  def title
    I18n.t(type.name.underscore, scope: 'activity.types').pluralize
  end

  def to_partial_path
    'activities/list'
  end

  def activities
    @activities ||= schedules.map(&method(:scheduled))
  end

  def group(activities)
    if grouped?
      activities.group_by(&:starts_at).to_a.sort_by(&:first).map(&:last)
    else
      [activities]
    end
  end

  def grouped?
    activities.map(&:starts_at).uniq.size < activities.size
  end

  def find(slug)
    scheduled(scope.find_by!(slug: slug).schedules.first)
  end

  delegate :each, :group_by, to: :activities

  private

  def scope
    type
      .includes(:schedules, presenters: :participant)
      .references(:schedules)
      .merge(Schedule.sorted)
      .where('activities.festival_id = ?', festival.id)
  end

  def schedules
    scope.all.flat_map(&:schedules)
  end

  def scheduled(schedule)
    ScheduledActivity.new(schedule)
  end
end
