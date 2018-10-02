# frozen_string_literal: true

class WaitlistHealthCheck
  attr_reader :festival

  def initialize(festival)
    @festival = festival
  end

  def call
    registrations.each do |registration|
      workshop_selections(registration)
        .group_by(&:slot)
        .each do |slot, selections|
          missing = expected(selections) - waitlisted(registration, selections)
          missing.each do |selection|
            waitlist!(selection, missing.size == selections.size)
          end
        end
    end
    true
  end

  private

  def waitlist!(selection, priority = false)
    selection
      .registration
      .waitlists
      .create!(schedule_id: selection.schedule_id)
      .tap { |w| w.move_to_top if priority }
  end

  def registrations
    festival
      .registrations
      .completed
      .includes(:waitlists, :participant, selections: { schedule: :activity })
      .reverse
  end

  def workshop_selections(registration)
    registration.selections.select { |s| s.schedule.activity.is_a?(Workshop) }
  end

  def waitlisted(registration, selections)
    schedule_ids = registration.waitlists.map(&:schedule_id)
    selections.select { |s| schedule_ids.include?(s.schedule_id) }
  end

  def expected(selections)
    allocated = selections.detect(&:allocated?)
    if allocated
      selections.select { |s| s.registered? && s.position < allocated.position }
    else
      selections
    end
  end
end
