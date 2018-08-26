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
    registration.update(completed_at: Time.zone.now)
  end
end
