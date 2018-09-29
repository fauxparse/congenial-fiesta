# frozen_string_literal: true

class FinanceSerializer < Primalize::Single
  attributes(
    total: integer,
    internet_banking: integer,
    pay_pal: integer,
    paid: integer,
    outstanding: integer
  )

  def total
    object.rows.map { |cart| cart.total }.inject(Money.new(0), &:+).to_i
  end

  def internet_banking
    total_paid_by(:internet_banking)
  end

  def pay_pal
    total_paid_by(:pay_pal)
  end

  def paid
    internet_banking + pay_pal
  end

  def outstanding
    object.rows.map(&:to_pay).inject(Money.new(0), &:+).to_i
  end

  def total_paid_by(kind)
    payments(kind.to_s).map(&:amount).inject(Money.new(0), &:+).to_i
  end

  def payments(kind)
    object.rows.flat_map do |cart|
      cart.payments.select { |p| p.kind == kind }
    end
  end
end
