# frozen_string_literal: true

class ParticipantMailer < ApplicationMailer
  helper MoneyHelper

  def registration_confirmation_email(registration)
    @registration = registration
    @participant = registration.participant
    @festival = registration.festival
    @cart = Cart.new(@registration, include_pending: false)
    mail to: @participant.email, subject: t('.subject', festival: @festival)
  end
end
