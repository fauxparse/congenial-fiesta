# frozen_string_literal: true

class ChangeSavedAtColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :registrations,
      :workshop_preferences_saved_at,
      :workshops_saved_at
    rename_column :registrations,
      :show_preferences_saved_at,
      :shows_saved_at
  end
end
