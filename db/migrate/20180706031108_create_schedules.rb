# frozen_string_literal: true

class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.belongs_to :activity, foreign_key: true
      t.timestamp :starts_at
      t.timestamp :ends_at

      t.timestamps

      t.index %i[starts_at ends_at]
    end
  end
end
