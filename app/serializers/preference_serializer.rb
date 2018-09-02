# frozen_string_literal: true

class PreferenceSerializer < Primalize::Single
  attributes(
    position: integer,
    name: string,
    starts_at: timestamp,
    ends_at: timestamp
  )

  delegate :schedule, to: :object
  delegate :activity, :starts_at, :ends_at, to: :schedule
  delegate :name, to: :activity
end
