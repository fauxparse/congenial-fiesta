# frozen_string_literal: true

class Payment < ApplicationRecord
  include Hashid::Rails

  belongs_to :registration

  monetize :amount_cents

  enum state: {
    pending: 'pending',
    approved: 'approved',
    cancelled: 'cancelled',
    declined: 'declined',
    refunded: 'refunded'
  }

  validates :registration_id, presence: true
  validates :amount,
    presence: true,
    numericality: { greater_than_or_equal_to: 0 }
  validates :payment_method, presence: true

  scope :in_place, -> { where(state: %i[pending approved]) }

  def payment_method
    @payment_method ||=
      PaymentMethod.const_get(self.class.name.demodulize).new(self)
  end

  def self.payment_method
    name.demodulize.underscore
  end

  def self.default_payment_type
    subclasses.first
  end
end

require_dependency 'payment/internet_banking'
