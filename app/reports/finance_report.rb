# frozen_string_literal: true

class FinanceReport < Report
  column(:participant) { |row| row.registration.participant.name }
  column(:count)
  column(:total) { |row| row.total.to_d }
  column(:paid) { |row| row.paid.to_d }
  column(:outstanding) { |row| row.to_pay.to_d }

  private

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
end
