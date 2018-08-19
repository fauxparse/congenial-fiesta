# frozen_string_literal: true

class Cart
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def total
    Money.new(0)
  end

  def to_partial_path
    'registrations/cart'
  end
end
