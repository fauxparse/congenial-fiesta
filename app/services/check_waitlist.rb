# frozen_string_literal: true

class CheckWaitlist
  attr_reader :schedule

  def initialize(schedule)
    @schedule = schedule
  end

  def call
    promote_waitlist if waitlist.present? && available?
  end

  private

  def waitlist
    @waitlist ||= schedule.waitlists.order(:position).first
  end

  def registration
    waitlist.registration
  end

  def selection
    @selection ||= Selection.find_or_initialize_by(
      registration: registration,
      schedule: schedule
    ).tap do |selection|
      @existing_selection = selection.persisted?
    end
  end

  def available?
    !schedule.maximum ||
      schedule
        .selections
        .allocated
        .included_in_limit
        .where.not(id: selection.id)
        .count < schedule.maximum
  end

  def promote_waitlist
    selection.allocated!
    other_selections.each(&:destroy)
    waitlist.destroy
    send_confirmation_email
    lower_priority_waitlists.each(&:destroy)
  end

  def other_selections
    registration
      .selections
      .allocated
      .where(slot: selection.slot)
      .where.not(id: selection.id)
      .all
  end

  def lower_priority_waitlists
    ids =
      if @existing_selection
        selection.lower_items.map(&:schedule_id)
      else
        registration
          .festival
          .schedules
          .all
          .select { |s| s.slot == schedule.slot }
          .map(&:id)
      end

    registration.waitlists.where(schedule_id: ids).all
  end

  def send_confirmation_email
    ParticipantMailer.waitlist_success_email(waitlist).deliver_now
  end
end
