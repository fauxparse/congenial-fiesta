# frozen_string_literal: true

class WorkshopsReport < Report
  MAX_CHOICES = 5

  column(:workshop) { |row| row.activity.name }
  column(:time) { |row| I18n.l(row.starts_at, format: :full) }
  column(:max) { |row| row.maximum }
  (1..MAX_CHOICES).each do |p|
    column(p) do |row|
      row.selections.reject(&:pending?).select { |s| s.position == p }.size
    end
  end
  column(:total) { |row| row.selections.reject(&:pending?).size }

  private

  def rows
    @rows =
      Schedule
        .includes(:activity, :selections)
        .references(:activities)
        .merge(Workshop.all)
        .order('schedules.starts_at ASC, schedules.id ASC')
  end
end
