# frozen_string_literal: true

class Cart
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def pricing_model
    @pricing_model ||= PricingModel.for_festival(registration.festival)
  end

  def count
    @count ||= workshops.uniq(&:slot).size
  end

  def total
    pricing_model.by_workshop_count(count)
  end

  def per_workshop
    pricing_model.by_workshop_count(1)
  end

  def to_partial_path
    'registrations/cart'
  end

  def workshops
    @workshops ||=
      registration
      .selections
      .includes(schedule: :activity)
      .references(:schedule, :activity)
      .merge(Schedule.not_freebie)
      .merge(Workshop.all)
      .reject(&:marked_for_destruction?)
  end
end
