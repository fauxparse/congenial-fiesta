# frozen_string_literal: true

class PitchSerializer < Primalize::Single
  attributes(
    id: string,
    name: string,
    pile: string,
    gender: string,
    origin: string
  )

  def id
    object.to_param
  end

  def name
    object.info.activity.name
  end

  def pile
    object.pile
  end

  def gender
    object.gender_list.first
  end

  def origin
    object.origin_list.first
  end
end
