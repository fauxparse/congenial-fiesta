# frozen_string_literal: true

require 'icalendar'
require 'icalendar/tzinfo'

class Calendar
  def initialize(festival, participant)
    @festival = festival
    @participant = participant
  end

  def events
    @events ||=
      (registered_events + public_events + presenting).sort.uniq(&:id)
  end

  def to_partial_path
    'calendar'
  end

  def to_ical
    ical = Icalendar::Calendar.new.tap do |calendar|
      events
        .flat_map { |e| [e.starts_at, e.ends_at] }
        .map { |t| Time.zone.tzinfo.ical_timezone(t) }
        .uniq
        .each { |z| calendar.add_timezone(z) }
      events.each do |event|
        publish_calendar_event(event, calendar)
      end
    end
    ical.to_ical
  end

  private

  attr_reader :festival, :participant

  def registration
    @registration ||=
      festival
        .registrations
        .completed
        .with_full_details
        .find_by(participant: participant) ||
        festival.registrations.build
  end

  def registered?
    registration.persisted?
  end

  def registered_events
    return [] unless registered?
    registration
      .selections
      .map { |s| selected(s) }
      .select(&:allocated?)
  end

  def presenting
    return [] unless participant
    festival
      .activities
      .with_presenters
      .includes(schedules: :venue)
      .references(:presenters)
      .where('presenters.participant_id = ?', participant)
      .flat_map(&:schedules)
      .map { |s| scheduled(s) }
  end

  def selected(selection)
    ScheduledActivity.new(
      selection.schedule,
      registration: registration,
      selection: selection
    )
  end

  def public_events
    festival
      .activities
      .with_presenters
      .includes(schedules: :venue)
      .where(type: %w[SocialEvent Forum])
      .flat_map { |a| a.schedules.map { |s| scheduled(s) } }
  end

  def scheduled(schedule)
    selection =
      registration.selections.detect { |s| s.schedule == schedule } ||
        registration.selections.build(schedule: schedule, state: :allocated)
    ScheduledActivity.new(
      schedule,
      registration: registration,
      selection: selection
    )
  end

  def publish_calendar_event(activity, calendar)
    calendar.event do |event|
      event.dtstart = ical_time(activity.starts_at)
      event.dtend = ical_time(activity.ends_at)
      event.summary = ical_text(activity.name)
      event.description = ical_text(event_description(activity))
      if activity.venue
        event.location = activity.venue.name
        event.geo =
          ical_array(activity.venue.latitude, activity.venue.longitude)
      end
    end
  end

  def event_description(activity)
    [
      I18n.t(activity.type.underscore, scope: 'activity.types'),
      activity.presenters.to_sentence
    ].reject(&:blank?).join(' with ')
  end

  def ical_time(time)
    Icalendar::Values::DateTime.new(
      time.to_datetime,
      'tzid' => Time.zone.tzinfo.name
    )
  end

  def ical_text(text)
    Icalendar::Values::Text.new(text)
  end

  def ical_array(*values)
    Icalendar::Values::Array.new(values, Icalendar::Values::Float)
  end
end
