# frozen_string_literal: true

class Identity
  class Password < Identity
    has_secure_password

    validates :type, uniqueness: { scope: :participant_id }
    validates :provider, :uid, absence: true

    def password?
      true
    end
  end
end
