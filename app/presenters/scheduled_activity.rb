# frozen_string_literal: true

class ScheduledActivity
  attr_reader :photo

  def initialize(schedule, registration: nil, photo: nil, available: true, selection: nil)
    @schedule = schedule
    @registration = registration
    @photo = photo
    @available = available
    @selection = selection
  end

  delegate :id, :starts_at, :ends_at, :slot, to: :schedule
  delegate :name, :description, :presenters, to: :activity
  delegate :position, to: :selection, allow_nil: true

  def <=>(other)
    if starts_at == other.starts_at
      id <=> other.id
    else
      starts_at <=> other.starts_at
    end
  end

  def to_partial_path
    "registrations/#{activity.type.underscore}"
  end

  def selected?
    selection.present?
  end

  def compulsory?
    if @compulsory.nil?
      @compulsory =
        presenters.map(&:participant).include?(registration.participant)
    end
    @compulsory
  end

  def available?
    @available.present? &&
      !compulsory? &&
      schedule.available?
  end

  def sorted_level_list
    if activity.respond_to?(:sorted_level_list)
      activity.sorted_level_list
    else
      []
    end
  end

  private

  attr_reader :selection, :registration, :schedule

  delegate :activity, to: :schedule
end
