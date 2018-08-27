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

  def paid
    sum_of(registration.payments.select(&:confirmed?))
  end

  def pending
    sum_of(registration.payments.select(&:pending?))
  end

  def paid?
    to_pay <= 0
  end

  def payment_confirmed?
    paid >= total
  end

  def to_pay
    total - paid - pending
  end

  def total
    workshop_cost
  end

  def per_workshop
    pricing_model.by_workshop_count(1)
  end

  def workshop_value
    per_workshop * count
  end

  def workshop_cost
    pricing_model.by_workshop_count(count)
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

  private

  def sum_of(payments)
    payments.map(&:amount).inject(Money.new(0), &:+)
  end
end
