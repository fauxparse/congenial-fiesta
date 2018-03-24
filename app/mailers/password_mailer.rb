# frozen_string_literal: true

class PasswordMailer < ApplicationMailer
  def password_reset_email(password_reset)
    @password_reset = password_reset
    @participant = password_reset.participant
    mail to: @participant.email
  end
end
