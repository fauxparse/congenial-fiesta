# frozen_string_literal: true

class CreateSelections < ActiveRecord::Migration[5.2]
  def change
    create_table :selections do |t|
      t.belongs_to :registration, foreign_key: { on_delete: :cascade }
      t.belongs_to :schedule, foreign_key: { on_delete: :cascade }
      t.string :state, limit: 16, default: 'pending'

      t.timestamps

      t.index %i[registration_id schedule_id], unique: true
      t.index %i[schedule_id state updated_at]
    end
  end
end
