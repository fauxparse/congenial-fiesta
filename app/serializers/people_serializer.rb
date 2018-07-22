# frozen_string_literal: true

class PeopleSerializer < Primalize::Many
  attributes(
    self: PersonSerializer,
    people: enumerable(PersonSerializer)
  )
end
