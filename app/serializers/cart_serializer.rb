# frozen_string_literal: true

class CartSerializer < Primalize::Single
  attributes(
    count: integer,
    total: primalize(MoneySerializer),
    workshops: array(primalize(PreferenceSerializer))
  )
end
