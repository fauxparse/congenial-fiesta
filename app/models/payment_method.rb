# frozen_string_literal: true

class PaymentMethod
  include Cry

  attr_reader :payment

  def initialize(payment)
    @payment = payment
  end

  def ===(other)
    to_param === other.to_param
  end

  def to_param
    self.class.to_param
  end

  def self.to_param
    name.demodulize.underscore
  end

  def self.to_partial_path
    'registrations/payment_method'
  end
end

require_dependency 'payment_method/pay_pal'
require_dependency 'payment_method/internet_banking'
