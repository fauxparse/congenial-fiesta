# frozen_string_literal: true

class Activities < ApplicationQuery
  class Parameters < QueryParameters
    property :type
  end

  attr_reader :festival

  def initialize(festival, parameters)
    @festival = festival
    super(parameters)
  end

  def types
    Activity.subclasses.map(&:name)
  end

  private

  def default_scope
    super.where(festival: festival).with_presenters.by_name
  end
end
