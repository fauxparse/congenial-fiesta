# frozen_string_literal: true

class ActivitySerializer < Primalize::Single
  attributes(
    id: integer,
    name: string,
    type: string,
    presenters: array(primalize(PresenterSerializer))
  )
end
