# frozen_string_literal: true

class ActivitiesSerializer < Primalize::Many
  attributes(
    activities: enumerable(ActivitySerializer),
    activity_types: enumerable(ActivityTypeSerializer)
  )
end
