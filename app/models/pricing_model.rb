# frozen_string_literal: true

class PricingModel
  PRICES = [0, 60, 110, 160, 205, 250, 285, 315, 340, 365, 390, 400].freeze

  def self.for_festival(_festival)
    # TODO: flesh this out when prices change
    new
  end

  def by_workshop_count(count)
    Money.new((count < PRICES.size ? PRICES[count] : PRICES.last) * 100)
  end
end
