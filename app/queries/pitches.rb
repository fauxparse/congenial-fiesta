# frozen_string_literal: true

class Pitches < ApplicationQuery
  class Parameters < QueryParameters
    property :status, default: 'submitted'
    property :type
    property :pile
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
    festival.pitches.includes(:participant).newest_first
  end
end
