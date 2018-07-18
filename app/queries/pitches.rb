# frozen_string_literal: true

class Pitches < ApplicationQuery
  class Parameters < QueryParameters
    property :status, default: 'submitted'
    property :type
    property :pile
    property :gender
    property :origin
  end

  attr_reader :festival

  def initialize(festival, parameters)
    @festival = festival
    super(parameters)
  end

  def statuses
    Pitch.statuses.except(:draft).values
  end

  def piles
    Pitch.piles.values
  end

  def types
    Pitch::ActivityInfo::TYPES
  end

  private

  def default_scope
    super.to(festival).by_participant
  end

  def gender(scope, gender)
    scope.tagged_with(gender, on: :gender)
  end

  def origin(scope, origin)
    scope.tagged_with(origin, on: :origin)
  end
end
