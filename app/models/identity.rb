# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :participant

  after_destroy :remove_admin_privileges, if: :last_identity_destroyed?

  enum provider:
    OmniAuth.registered_providers.map { |p| [p, p.to_s] }.to_h.freeze

  scope :password, -> { where(type: 'Identity::Password') }

  private

  def remove_admin_privileges
    participant.update!(admin: false) if participant.admin?
  end

  def last_identity_destroyed?
    participant.identities.reload.empty?
  end

  def password?
    false
  end
end
