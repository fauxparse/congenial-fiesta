# frozen_string_literal: true

class Participant < ApplicationRecord
  include Hashid::Rails
  include Nationalisable

  auto_strip_attributes :name, :email

  has_many :identities, dependent: :destroy, autosave: true
  has_many :password_resets
  has_many :pitches, dependent: :destroy
  has_many :registrations, dependent: :destroy
  has_many :payments, through: :registrations

  has_one_attached :avatar

  acts_as_taggable_on :role

  before_validation :remove_admin_if_cannot_log_in

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, if: :email?
  validates :email, email: { allow_blank: true }
  validates_associated :identities

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

  def role?(role)
    role_list.include?(role.to_s)
  end

  private

  def remove_admin_if_cannot_log_in
    self.admin = false unless can_log_in?
  end

  def can_log_in?
    identities.reject(&:marked_for_destruction?).any?
  end
end
