# frozen_string_literal: true

class MoneySerializer < Primalize::Single
  attributes(
    amount: integer,
    currency: string(&:to_s),
    formatted: string
  )

  def amount
    object.cents
  end

  def formatted
    object.format
  end
end
