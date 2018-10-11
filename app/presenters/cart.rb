# frozen_string_literal: true

class Cart
  attr_reader :registration

  def initialize(registration, include_pending: true)
    @registration = registration
    @include_pending = include_pending
  end

  def include_pending?
    @include_pending
  end

  def pricing_model
    @pricing_model ||= PricingModel.for_festival(registration.festival)
  end

  def count
    workshops.uniq(&:slot).size
  end

  def paid
    sum_of(registration.payments.select(&:approved?))
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
    total - paid - (include_pending? ? pending : 0)
  end

  def total
    workshop_cost - voucher_discount
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

  def voucher_discount
    pricing_model.by_workshop_count(discounted_workshop_count)
  end

  def discounted_workshop_count
    [count, registration.vouchers.sum(&:workshop_count)].min
  end

  def to_partial_path
    'registrations/cart'
  end

  def workshops
    registration
      .selections
      .select { |s| s.schedule.activity.is_a?(Workshop) }
      .select { |s| count_selection?(s) }
      .reject { |s| s.schedule.freebie? }
      .reject(&:marked_for_destruction?)
  end

  def payments
    all = registration.payments.sort_by(&:created_at)
    all.select do |payment|
      payment.approved? || (include_pending? && payment.pending?)
    end
  end

  private

  def sum_of(payments)
    payments.map(&:amount).inject(Money.new(0), &:+)
  end

  def count_selection?(selection)
    if earlybird?
      selection.position == 1
    else
      selection.allocated?
    end
  end

  def registration_stage
    @registration_stage ||= RegistrationStage.new(registration.festival)
  end

  def earlybird?
    registration_stage.earlybird?
  end
end
