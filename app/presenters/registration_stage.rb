# frozen_string_literal: true

class RegistrationStage
  attr_reader :festival

  def initialize(festival)
    @festival = festival
  end

  def open?
    festival.registrations_open_at? &&
      registration_period.include?(Time.zone.now)
  end

  def earlybird?
    festival.registrations_open_at? &&
      earlybird_cutoff &&
      earlybird_period.include?(Time.zone.now)
  end

  def registration_period
    (festival.registrations_open_at...end_of_festival)
  end

  def earlybird_period
    (festival.registrations_open_at...festival.earlybird_cutoff)
  end

  def earlybird_cutoff
    festival.earlybird_cutoff || end_of_festival
  end

  def end_of_festival
    (festival.end_date + 1).beginning_of_day
  end
end
