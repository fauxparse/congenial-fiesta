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

  def to_s
    self.class.to_s
  end

  alias to_param to_s

  def self.to_s
    name.demodulize.underscore
  end

  def self.to_param
    to_s
  end

  def self.to_partial_path
    'registrations/payment_method'
  end

  def self.all
    subclasses.sort_by(&:name)
  end

  def self.kinds
    all.map { |k| k.name.demodulize.underscore }.sort
  end
end

require_dependency 'payment_method/internet_banking'
require_dependency 'payment_method/pay_pal'
