# frozen_string_literal: true

class TimetableSerializer < Primalize::Many
  attributes(
    schedules: enumerable(ScheduleSerializer),
    activities: enumerable(ActivitySerializer),
    activity_types: enumerable(ActivityTypeSerializer)
  )
end
