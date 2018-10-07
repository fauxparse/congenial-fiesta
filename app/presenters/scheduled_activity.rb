# frozen_string_literal: true

class ScheduledActivity
  def initialize(schedule,
    registration: nil, available: true, selection: nil, clash: false)
    @schedule = schedule
    @registration = registration
    @available = available
    @selection = selection
    @clash = clash
  end

  delegate :id, :starts_at, :ends_at, :slot, :venue, to: :schedule
  delegate :name, :description, :photo, :presenters, :to_param, :type,
    to: :activity
  delegate :position, :allocated?, to: :selection, allow_nil: true

  def <=>(other)
    if starts_at == other.starts_at
      id <=> other.id
    else
      starts_at <=> other.starts_at
    end
  end

  def to_partial_path
    activity.type.underscore
  end

  def selected?
    selection.present?
  end

  def waitlisted?
    waitlist.present?
  end

  def state
    if waitlisted?
      'waitlisted'
    else
      selection&.state || 'unselected'
    end
  end

  def compulsory?
    if @compulsory.nil?
      @compulsory =
        presenters.map(&:participant).include?(registration.participant)
    end
    @compulsory
  end

  def clash?
    @clash.present?
  end

  def available?
    (@available.present? || selected?) && !compulsory?
  end

  def waitlisted?
    registration.waitlists.any? { |w| w.schedule_id == id }
  end

  def sorted_level_list
    if activity.respond_to?(:sorted_level_list)
      activity.sorted_level_list
    else
      []
    end
  end

  def day
    schedule.starts_at.to_date
  end

  def for_show?
    activity.is_a?(Workshop) &&
      activity.pitch &&
      activity.pitch.activities.any? { |a| a.is_a?(Show) && a.schedules.any? }
  end

  def <=>(other)
    if slot == other.slot
      id <=> other.id
    else
      starts_at <=> other.starts_at
    end
  end

  private

  def waitlist
    registration.waitlists.detect { |w| w.schedule_id == schedule.id }
  end

  attr_reader :selection, :registration, :schedule

  delegate :activity, to: :schedule
end
