# frozen_string_literal: true

class WashupReport < Report
  column(:participant) { |row| row.registration.participant.name }
  column(:email) { |row| row.registration.participant.email }
  column(:selected) do |row|
    schedules = row.registration.selections.map(&:schedule) +
      row.registration.waitlists.map(&:schedule)
    schedules
      .select { |s| s.activity.is_a?(Workshop) }
      .map(&:slot)
      .uniq
      .size
  end
  column(:taken) do |row|
    row
      .registration
      .selections
      .select { |s| s.activity.is_a?(Workshop) && s.allocated? }
      .size
  end
  column(:total) { |row| row.total.to_d }
  column(:internet) { |row| total_paid(row, PaymentMethod::InternetBanking) }
  column(:paypal) { |row| total_paid(row, PaymentMethod::PayPal) }
  column(:voucher) { |row| row.voucher_discount }
  column(:outstanding) { |row| row.to_pay.to_d }

  def rows
    @rows =
      festival
      .registrations
      .completed
      .includes(
        :participant,
        :payments,
        selections: { schedule: :activity }
      )
      .references(:participants, :activities)
      .merge(Workshop.all)
      .order('participants.name ASC')
      .map { |row| Cart.new(row, include_pending: false) }
  end

  private

  def self.total_paid(row, payment_method)
    payments = row.registration.payments.select do |p|
      p.payment_method.is_a?(payment_method)
    end
    payments.select(&:approved?).map(&:amount).inject(Money.new(0), &:+)
  end
end
