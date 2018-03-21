# frozen_string_literal: true

class Participant < ApplicationRecord
  auto_strip_attributes :name, :email

  has_many :identities, dependent: :destroy, autosave: true

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, email: true

  scope :with_email, ->(email) { where('LOWER(email) = ?', email&.downcase) }

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
