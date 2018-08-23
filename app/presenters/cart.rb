# frozen_string_literal: true

class Cart
  attr_reader :registration

  def initialize(registration)
    @registration = registration
  end

  def count
    @count ||= workshops.uniq(&:slot).size
  end

  def total
    Money.new(count * (6500 - (count - 1) * 500))
  end

  def to_partial_path
    'registrations/cart'
  end

  def workshops
    @workshops ||=
      registration
        .preferences
        .select { |p| p.activity.is_a? Workshop }
        .reject(&:marked_for_destruction?)
  end
end
