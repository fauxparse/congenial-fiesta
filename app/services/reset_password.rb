# frozen_string_literal: true

class ResetPassword
  attr_reader :email

  def initialize(email)
    @email = email
  end

  def call
    generate_and_send if participant.present?
  end

  private

  def participant
    @participant ||= Participant.with_email(email).first
  end

  def generate_and_send
    PasswordMailer.password_reset_email(password_reset).deliver_later
  end

  def password_reset
    @password_reset ||= PasswordReset.create(participant: participant)
  end
end
