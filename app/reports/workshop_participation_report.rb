# frozen_string_literal: true

class WorkshopParticipationReport < Report
  column(:time) { |row| I18n.l(row[:time], format: :full) }
  column(:workshop) { |row| row[:workshop] }
  column(:participant) { |row| row[:participant] }

  private

  def rows
    @rows =
      festival
        .workshops
        .includes(
          schedules: {
            waitlists: {
              registration: :participant
            },
            selections: :participant
          }
        )
        .all
        .flat_map(&:schedules)
        .sort
        .group_by(&:slot)
        .to_a
        .flat_map { |slot, schedules| rows_for_slot(slot, schedules) }
  end

  def rows_for_slot(slot, schedules)
    schedules
      .sort_by { |s| s.activity.name }
      .flat_map { |s| participant_rows(s) }
      .concat(waitlist_rows(schedules))
  end

  def participant_rows(schedule)
    schedule
      .selections
      .select(&:allocated?)
      .sort_by(&:participant)
      .map do |s|
        row(schedule.starts_at, schedule.activity.name, s.participant.name)
      end
  end

  def waitlist_rows(schedules)
    schedules
      .flat_map(&:waitlists)
      .sort_by { |s| s.registration.participant }
      .map do |w|
        row(
          w.schedule.starts_at,
          '(none)',
          w.registration.participant.name
        )
      end
  end

  def row(time, workshop, participant)
    {
      time: time,
      workshop: workshop,
      participant: participant
    }
  end
end
