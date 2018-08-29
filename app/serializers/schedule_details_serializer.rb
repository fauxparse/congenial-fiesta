# frozen_string_literal: true

class ScheduleDetailsSerializer < ScheduleSerializer
  include TextHelper
  include Admin::TimetableHelper

  attributes(
    name: string,
    description: string,
    presenters: string,
    date: string,
    times: string,
    levels: array(string),
    bios: array(string)
  )

  delegate :activity, to: :object
  delegate :name, to: :activity

  def description
    markdown(activity.description)
  end

  def presenters
    activity.presenters.to_sentence
  end

  def date
    I18n.l(object.starts_at.to_date, format: :timetable)
  end

  def times
    time_range(object.starts_at, object.ends_at)
  end

  def levels
    activity.respond_to?(:levels) ? activity.sorted_level_list : []
  end

  def bios
    activity
      .presenters
      .map { |p| p.participant.bio }
      .reject(&:blank?)
      .map(&method(:markdown))
  end
end
