# frozen_string_literal: true

class Payments < ApplicationQuery
  class Parameters < QueryParameters
    property :state, default: 'pending'
    property :kind
  end

  attr_reader :festival

  def initialize(festival, parameters)
    @festival = festival
    super(parameters)
  end

  def states
    Payment.states.values
  end

  def kinds
    PaymentMethod.all
  end

  private

  def default_scope
    super
      .includes(registration: :participant)
      .references(:registrations)
      .merge(Registration.completed)
      .where('registrations.festival_id = ?', festival.id)
      .order('payments.created_at DESC')
  end
end
