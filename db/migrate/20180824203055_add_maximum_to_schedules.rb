# frozen_string_literal: true

class AddMaximumToSchedules < ActiveRecord::Migration[5.2]
  def up
    add_column :schedules, :maximum, :integer

    Schedule.includes(:activity).each do |schedule|
      schedule.update!(maximum: schedule.activity.maximum)
    end
  end

  def down
    remove_column :schedules, :maximum
  end
end
