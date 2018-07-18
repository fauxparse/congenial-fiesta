# frozen_string_literal: true

class ScheduleSerializer < Primalize::Single
  attributes(
    id: integer,
    venue_id: optional(integer),
    activity_id: integer,
    starts_at: timestamp,
    ends_at: timestamp
  )
end
