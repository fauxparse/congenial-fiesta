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

  delegate :starts_at, :ends_at, to: :schedule
end
