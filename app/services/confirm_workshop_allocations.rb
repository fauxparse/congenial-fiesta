# frozen_string_literal: true

class ConfirmWorkshopAllocations
  def initialize(allocations)
    @allocations = allocations
  end

  def call
    Selection.transaction do
      allocations.each do |slot, matches|
        waitlist_all(slot, matches[nil] || [])
        matches.each do |schedule, registrations|
          confirm(schedule, registrations) if schedule
        end
      end
    end
  end

  private

  attr_reader :allocations

  def confirm(schedule, registrations)
    registrations.each do |registration|
      successful =
        registration.selections.detect { |s| s.schedule_id == schedule.id }
      successful.allocated!
      registration
        .selections
        .reject(&:excluded?)
        .select { |s| s.slot == successful.slot }
        .select { |s| s.position < successful.position }
        .each { |s| waitlist(s) }
    end
  end

  def waitlist(selection)
    selection.schedule.waitlists.create(
      registration: selection.registration
    )
  end

  def waitlist_all(slot, registrations)
    registrations
      .flat_map(&:selections)
      .select { |s| s.slot == slot }
      .each { |selection| waitlist(selection) }
  end

  attr_reader :allocations
end
