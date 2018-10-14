# frozen_string_literal: true

class Roll
  attr_reader :schedule

  def initialize(schedule)
    @schedule = schedule
  end

  def participants
    @participants ||=
      schedule
        .selections
        .allocated
        .includes(registration: :participant)
        .map { |s| s.registration.participant }
        .sort
  end

  def workshop
    schedule.activity
  end

  delegate :starts_at, :ends_at, to: :schedule
  delegate :name, to: :workshop
end
