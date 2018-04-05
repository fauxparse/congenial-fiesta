# frozen_string_literal: true

class PitchForm
  class Step
    class Presenter < Step
      FIELDS = %i[city country_code company presented_before bio].freeze

      validate :valid_participant, if: :new_participant?
      validates :name, :city, :country_code, :bio, presence: true
      validates :code_of_conduct, acceptance: true

      def presenter_info
        info.presenter
      end

      def presenter=(attributes)
        self.attributes = attributes
      end

      def name
        presenter_info.name.presence || participant.name
      end

      def name=(value)
        participant.name = value if new_participant?
        presenter_info.name = value
      end

      def email=(value)
        participant.email = value if new_participant?
      end

      def password=(value)
        participant_password.password = value if new_participant?
      end

      def password_confirmation=(value)
        participant_password.password_confirmation = value if new_participant?
      end

      delegate(
        *FIELDS.flat_map { |f| [f, :"#{f}="] },
        to: :presenter_info
      )

      def code_of_conduct
        info.code_of_conduct_accepted ? '1' : '0'
      end

      def code_of_conduct=(value)
        info.code_of_conduct_accepted = value.to_b
      end

      def permit(params)
        params.permit(
          :code_of_conduct,
          presenter:
            [:name, :email, :password, :password_confirmation, *FIELDS]
        )
      end

      def apply!
        save_new_participant && super
      end

      private

      def participant_password
        participant.identities.detect(&:password?) ||
          participant.identities.build(type: Identity::Password)
      end

      def new_participant?
        participant.new_record?
      end

      def save_new_participant
        !new_participant? || participant.save
      end

      def valid_participant
        [participant, participant_password].each do |record|
          record.errors.each { |attr, message| errors.add(attr, message) } \
            unless record.valid?
        end
      end
    end
  end
end
