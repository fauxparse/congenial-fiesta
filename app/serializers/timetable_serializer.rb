# frozen_string_literal: true

class TimetableSerializer < Primalize::Many
  attributes(
    schedules: enumerable(ScheduleSerializer),
    activities: enumerable(ActivitySerializer)
  )
end
