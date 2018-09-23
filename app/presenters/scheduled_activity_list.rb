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
      activities.group_by(&:starts_at).values.sort_by(&:first)
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

  def each_day(&block)
    activities.sort.group_by(&:day).each do |day, group|
      yield day, group
    end
  end

  delegate :each, to: :activities

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
