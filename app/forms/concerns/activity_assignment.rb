# frozen_string_literal: true

module ActivityAssignment
  extend ActiveSupport::Concern

  def update_preferences(preferences, type: Activity)
    remove_old_preferences(preferences, type: type)
    add_new_preferences(preferences)
  end

  private

  def remove_old_preferences(preferences, type:)
    registration
      .preferences
      .select { |p| p.activity.is_a?(type) }
      .reject { |p| preferences.include?(p.schedule_id) }
      .map(&:mark_for_destruction)
  end

  def add_new_preferences(by_id)
    by_id.each do |schedule_id, position|
      find_or_build_preference(schedule_id).position = position
    end
  end

  def find_or_build_preference(schedule_id)
    registration.preferences.detect { |p| p.schedule_id == schedule_id } ||
      registration.preferences.build(schedule: Schedule.find(schedule_id))
  end
end
