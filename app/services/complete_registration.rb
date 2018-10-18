# frozen_string_literal: true

class CompleteRegistration
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def call
    confirm_selections
    first_time_completion unless completed?
  end

  private

  delegate :completed?, to: :registration
  delegate :earlybird?, to: :registration_stage

  def pending_selections
    registration
      .selections
      .pending
      .includes(schedule: :activity)
  end

  def confirm_selections
    pending_selections.each do |selection|
      if earlybird? && selection.schedule.activity.is_a?(Workshop)
        selection.registered!
      else
        selection.allocated!
      end
    end
  end

  def registration_stage
    @registration_stage ||= RegistrationStage.new(registration.festival)
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
