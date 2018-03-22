# frozen_string_literal: true

class SignupForm
  include ActiveModel::Validations

  validates :email, presence: true
  validates :password, confirmation: true, if: :password

  attr_reader :participant, :password_confirmation

  def initialize(attributes = {})
    @participant = Participant.new(attributes.slice(:name, :email))
    @participant.identities << password_identity(attributes.slice(:password))
    @password_confirmation = attributes[:password_confirmation]
  end

  def to_model
    participant
  end

  def save
    valid? && participant.save
  end

  delegate :name, :email, to: :participant
  delegate :password, to: :password_identity

  private

  def password_identity(attributes = {})
    @password_identity ||= Identity::Password.new(attributes)
  end

  def run_validations!
    super
    [participant, password_identity].each do |object|
      object.validate
      object.errors.each { |attribute, error| errors.add(attribute, error) }
    end
    errors.empty?
  end
end
