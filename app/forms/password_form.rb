# frozen_string_literal: true

class PasswordForm
  extend ActiveModel::Naming
  include ActiveModel::Validations

  attr_reader :participant, :params

  validate :current_password_matches, if: :existing_password?
  validate :passwords_match

  def initialize(participant, params)
    @participant = participant
    @params = params
    @existing_password = identity.persisted?
    identity.password = params[:password]
    identity.password_confirmation = params[:password_confirmation]
  end

  def save
    valid? && identity.save
  end

  def current_password
    nil
  end

  def password
    nil
  end

  def password_confirmation
    nil
  end

  def to_model
    self
  end

  def persisted?
    true
  end

  def existing_password?
    @existing_password
  end

  private

  def identity
    @identity ||=
      participant.identities.detect(&:password_digest?) ||
      new_password_identity
  end

  def new_password_identity
    Identity::Password.new(
      password: params[:password],
      password_confirmation: params[:password_confirmation],
      participant: participant
    )
  end

  def current_password_matches
    errors.add(:current_password, :mismatch) unless current_password_matches?
  end

  def current_password_matches?
    BCrypt::Password.new(current_password_digest) == params[:current_password]
  end

  def current_password_digest
    identity.password_digest_changed? &&
      identity.password_digest_was ||
      identity.password_digest
  end

  def passwords_match
    identity.validate
    identity.errors.each { |attribute, error| errors.add(attribute, error) }
  end
end
