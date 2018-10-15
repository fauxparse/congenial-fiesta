# frozen_string_literal: true

class UpdateAmountPending
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def call
    update_pending_payment if should_update?
  end

  private

  delegate :completed?, to: :registration

  def cart
    @cart ||= Cart.new(registration, include_pending: false)
  end

  def earlybird_registration?
    RegistrationStage.new(registration.festival).earlybird?
  end

  def update_pending_payment
    pending_payment.update!(amount: cart.to_pay)
  end

  def should_update?
    registration.completed? &&
      !earlybird_registration? &&
      pending_payment.present?
  end

  def pending_payment
    @pending_payment ||= registration.payments.pending.first
  end
end
