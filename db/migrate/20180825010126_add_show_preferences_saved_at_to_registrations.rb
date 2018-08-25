# frozen_string_literal: true

class AddShowPreferencesSavedAtToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :show_preferences_saved_at, :timestamp
  end
end
