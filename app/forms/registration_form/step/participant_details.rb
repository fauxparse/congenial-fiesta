# frozen_string_literal: true

class RegistrationForm
  class Step
    class ParticipantDetails < Step
      permit :name, :email, :city, :country_code
      permit :password, :password_confirmation

      delegate :participant, to: :form
      delegate :name, :email, :city, :country_code, to: :participant
      delegate :name=, :email=, :city=, :country_code=, to: :participant
      delegate :password, :password_confirmation, to: :identity
      delegate :password=, :password_confirmation=, to: :identity

      validate :participant_can_log_in
      validates :name, :email, :city, :country_code, presence: true

      def to_param
        'details'
      end

      private

      def identity
        @identity ||=
          participant.identities.detect(&:password?) ||
          participant.identities.build(type: 'Identity::Password')
      end

      def participant_can_log_in
        errors.add(:participant_id, :must_have_account) unless can_log_in?
      end

      def can_log_in?
        participant.identities.select(&:persisted?).any? || identity.valid?
      end

      def save
        participant.save
        super
      end
    end
  end
end
