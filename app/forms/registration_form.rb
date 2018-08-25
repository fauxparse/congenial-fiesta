# frozen_string_literal: true

class RegistrationForm
  include ActiveModel::Conversion
  include Cry

  attr_reader :festival

  def initialize(festival, participant, step: nil)
    @festival = festival
    @participant = participant
    @step = step
  end

  def registration
    @registration ||=
      festival
        .registrations
        .includes(preferences: { schedule: :activity })
        .find_or_initialize_by(participant: @participant)
  end

  def participant
    registration.participant || registration.build_participant
  end

  def assign_attributes(params)
    current_step.assign_attributes(params)
  end

  def update(params)
    if current_step.update(params)
      advance!
    else
      publish(:show, current_step)
    end
  end

  def current_step
    @current_step ||=
      accessible_steps.detect { |step| step.to_param == @step } ||
      accessible_steps.last
  end

  def next_step
    current_step.next
  end

  def previous_step
    current_step.previous
  end

  def steps
    @steps ||= [
      Step::ParticipantDetails.new(self),
      Step::CodeOfConduct.new(self),
      Step::WorkshopSelection.new(self),
      Step::ShowSelection.new(self),
      Step::PaymentDetails.new(self)
    ].freeze
  end

  def accessible_steps
    @accessible_steps ||= steps.take_while do |step|
      step.first? || step.complete? || step.previous.complete?
    end
  end

  def permitted_attributes
    current_step.permitted_attributes
  end

  def cart
    @cart ||= Cart.new(registration)
  end

  delegate :to_partial_path, to: :current_step

  private

  def advance!
    if current_step.last?
      publish(:completed)
    else
      @current_step = next_step
      publish(:advance, current_step)
    end
  end
end
