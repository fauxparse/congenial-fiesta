# frozen_string_literal

class RegistrationSummarySerializer < Primalize::Single
  attributes(
    count: integer,
    histogram: object,
    bookings: object(
      workshops: object(capacity: integer, booked: integer),
      shows: object(capacity: integer, booked: integer)
    )
  )

  def count
    registrations.size
  end

  def histogram
    workshop_counts.to_a.group_by(&:last).transform_values(&:size)
  end

  def bookings
    [Workshop, Show]
      .map { |type| [type.name.underscore.pluralize.to_sym, capacity(type)] }
      .to_h
  end

  private

  def registrations
    @registrations ||=
      object
      .registrations
      .completed
      .includes(selections: { schedule: :activity })
  end

  def workshop_counts
    registrations.map { |r| [r, booked_activity_count(r, Workshop)] }.to_h
  end

  def booked_activity_count(registration, type)
    registration
      .selections
      .select { |s| s.activity.is_a?(type) }
      .uniq(&:slot)
      .size
  end

  def workshop_count(registration)
    registration
      .selections
      .select { |s| s.activity.is_a?(Workshop) }
      .uniq(&:slot)
      .size
  end

  def schedules
    @schedules ||= object.schedules.includes(:activity)
  end

  def schedules_of(type)
    schedules.select { |s| s.activity.is_a?(type) }
  end

  def capacity(type)
    {
      capacity: schedules_of(type).map(&:maximum).compact.sum,
      booked: registrations.map { |r| booked_activity_count(r, type) }.sum
    }
  end
end
