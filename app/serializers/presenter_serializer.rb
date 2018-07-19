# frozen_string_literal: true

class PresenterSerializer < Primalize::Single
  attributes(
    id: integer,
    name: string
  )

  def id
    object.participant_id
  end

  def name
    object.participant.name
  end
end
