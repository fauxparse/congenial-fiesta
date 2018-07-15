# frozen_string_literal: true

class PresenterSerializer < Primalize::Single
  attributes(
    name: string
  )

  def name
    object.participant.name
  end
end
