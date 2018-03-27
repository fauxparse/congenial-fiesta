# frozen_string_literal: true

class LoginForm
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Validations

  attr_reader :email

  validate :authenticates_participant

  def initialize(email: nil, password: nil)
    @email = email
    @password = password
  end

  def participant
    @participant ||= authenticated_identity&.participant
  end

  def password
    nil
  end

  def to_key
    [:login]
  end

  def to_model
    self
  end

  def model_name
    @model_name ||= ActiveModel::Name.new(self, nil, 'Login')
  end

  def persisted?
    false
  end

  private

  def authenticated_identity
    find_participant_for_authentication
      &.identities
      &.password
      &.first
      &.authenticate(@password) || nil
  end

  def find_participant_for_authentication
    Participant.password_authenticated.with_email(email).first
  end

  def authenticates_participant
    errors.add(:email, :invalid) unless participant.present?
  end
end
