# frozen_string_literal: true

class ScheduledActivity
  attr_reader :photo

  def initialize(schedule, registration: nil, photo: nil, available: true)
    @schedule = schedule
    @registration = registration
    @photo = photo
    @available = available
  end

  delegate :id, :starts_at, :ends_at, :slot, to: :schedule
  delegate :name, :description, :presenters, to: :activity
  delegate :position, to: :preference, allow_nil: true

  def <=>(other)
    if starts_at == other.starts_at
      id <=> other.id
    else
      starts_at <=> other.starts_at
    end
  end

  def to_partial_path
    'registrations/activity'
  end

  def selected?
    position.present?
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

  private

  def preference
    @preference ||=
      registration.preferences.detect do |p|
        p.schedule_id == schedule.id
      end
  end

  attr_reader :registration, :schedule

  delegate :activity, to: :schedule
end
