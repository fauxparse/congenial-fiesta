# frozen_string_literal: true

class Identity
  class Oauth < Identity
    validates :provider, :uuid, presence: true
    validates :provider,
      uniqueness: { scope: :participant_id, case_sensitive: false }
    validates :password_digest, absence: true
  end
end
