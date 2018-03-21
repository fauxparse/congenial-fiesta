# frozen_string_literal: true

class Participant < ApplicationRecord
  auto_strip_attributes :name, :email

  has_many :identities, dependent: :destroy, autosave: true

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, if: :email?
  validates :email, email: { allow_blank: true }

  scope :with_email, ->(email) { where('LOWER(email) = ?', email&.downcase) }

  def to_s
    # In case the user is changing their name to an invalid value
    name_changed? ? name_was : name
  end

  def self.password_authenticated
    joins(:identities)
      .merge(Identity.password)
      .group('participants.id')
      .having('COUNT(identities.id) > 0')
  end

  def password?
    identities.any?(&:password_digest?)
  end
end
