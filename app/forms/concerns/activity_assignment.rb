# frozen_string_literal: true

module ActivityAssignment
  extend ActiveSupport::Concern

  def update_selections(selections, type: Activity)
    remove_old_selections(selections, type: type)
    add_new_selections(selections)
  end

  private

  def remove_old_selections(selections, type:)
    registration
      .selections
      .select { |s| s.activity.is_a?(type) && !s.schedule.freebie? }
      .reject { |s| selections.include?(s.schedule_id) }
      .map(&:mark_for_destruction)
  end

  def add_new_selections(by_id)
    by_id.each do |schedule_id, position|
      selection = find_or_build_selection(schedule_id)
      selection.position = position
      selection.state = new_selection_state(selection.schedule) \
        if registration.completed?
    end
  end

  def new_selection_state(schedule)
    if earlybird? && schedule.activity.is_a?(Workshop)
      'registered'
    else
      'allocated'
    end
  end

  def registration_stage
    @registration_stage ||= RegistrationStage.new(registration.festival)
  end

  delegate :earlybird?, to: :registration_stage

  def find_or_build_selection(schedule_id)
    registration.selections.detect { |s| s.schedule_id == schedule_id } ||
      registration.selections.build(schedule: Schedule.find(schedule_id))
  end
end
