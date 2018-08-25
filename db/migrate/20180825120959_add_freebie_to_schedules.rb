# frozen_string_literal: true

class AddFreebieToSchedules < ActiveRecord::Migration[5.2]
  def change
    add_column :schedules, :freebie, :boolean, default: false
  end
end
