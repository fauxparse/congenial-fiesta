# frozen_string_literal: true

class ScheduledActivity
  attr_reader :photo

  def initialize(schedule, registration: nil, photo: nil)
    Rails.logger.info photo
    @schedule = schedule
    @registration = registration
    @photo = photo
  end

  delegate :id, :starts_at, :ends_at, to: :schedule
  delegate :name, :description, :presenters, to: :activity

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

  private

  attr_reader :registration, :schedule

  delegate :activity, to: :schedule
end
