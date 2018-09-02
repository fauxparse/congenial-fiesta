# frozen_string_literal: true

class CompleteRegistration
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def call
    registration.selections.pending.each(&selection_action)
    first_time_completion unless completed?
  end

  private

  delegate :completed?, to: :registration
  delegate :earlybird?, to: :registration_stage

  def registration_stage
    @registration_stage ||= RegistrationStage.new(registration.festival)
  end

  def selection_action
    earlybird? ? :registered! : :allocated!
  end

  def first_time_completion
    registration.update(completed_at: Time.zone.now, state: new_state)
    ParticipantMailer
      .registration_confirmation_email(registration)
      .deliver_later
  end

  def cart
    @cart ||= Cart.new(registration)
  end

  def new_state
    cart.payment_confirmed? ? :confirmed : :awaiting_payment
  end
end
