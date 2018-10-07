# frozen_string_literal: true

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
end
