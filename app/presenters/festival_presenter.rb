# frozen_string_literal: true

class FestivalPresenter < SimpleDelegator
  alias festival __getobj__

  def workshops_count
    activity_count(Workshop)
  end

  def shows_count
    activity_count(Show)
  end

  def registrations_open?
    registrations.open?
  end

  def earlybird?
    registrations.earlybird?
  end

  private

  def registrations
    @registrations ||= RegistrationStage.new(festival)
  end

  def activity_count(type)
    @counts ||= {}
    @counts[type.name] ||=
      festival
      .activities
      .joins('INNER JOIN schedules ON schedules.activity_id = activities.id')
      .merge(type.all)
      .count
  end
end
