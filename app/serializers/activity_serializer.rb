# frozen_string_literal: true

class ActivitySerializer < Primalize::Single
  attributes(
    id: optional(integer),
    name: string,
    type: string,
    maximum: optional(integer),
    presenters: array(primalize(PresenterSerializer))
  )
end
