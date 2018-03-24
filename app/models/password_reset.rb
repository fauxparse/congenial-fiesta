# frozen_string_literal: true

class PasswordReset < ApplicationRecord
  TIME_TO_LIVE = 1.day

  belongs_to :participant

  has_secure_token

  before_validation :regenerate_token, unless: :token?
  before_validation :fill_in_expiry, unless: :expires_at?

  validates :token, :expires_at, presence: true

  scope :active, -> { where('expires_at > ?', Time.zone.now) }

  def to_param
    token
  end

  def expired?
    expires_at <= Time.zone.now
  end

  private

  def fill_in_expiry
    self.expires_at = Time.zone.now + TIME_TO_LIVE
  end
end
