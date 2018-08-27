# frozen_string_literal: true

class Payment < ApplicationRecord
  belongs_to :registration

  monetize :amount_cents

  enum state: {
    pending: 'pending',
    confirmed: 'confirmed',
    cancelled: 'cancelled',
    declined: 'declined',
    refunded: 'refunded'
  }

  validates :registration_id, presence: true
  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  scope :in_place, -> { where(state: %i[pending confirmed]) }

  def payment_method
    self.class.payment_method
  end

  def self.payment_method
    name.demodulize.underscore
  end

  def self.default_payment_type
    subclasses.first
  end
end

require_dependency 'payment/internet_banking'
