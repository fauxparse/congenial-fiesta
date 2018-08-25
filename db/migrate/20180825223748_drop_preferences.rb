# frozen_string_literal: true

class DropPreferences < ActiveRecord::Migration[5.2]
  def up
    drop_table :preferences
  end

  def down
    create_table :preferences do |t|
      t.belongs_to :registration, foreign_key: { on_delete: :cascade }
      t.belongs_to :schedule, foreign_key: { on_delete: :cascade }
      t.integer :position
      t.integer :slot

      t.timestamps

      t.index %i[registration_id schedule_id], unique: true
      t.index %i[registration_id slot]
    end

    add_column :registrations, :workshop_preferences_saved_at, :timestamp
  end
end
