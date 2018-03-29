# frozen_string_literal: true

class CreatePitches < ActiveRecord::Migration[5.2]
  def change
    create_table :pitches do |t|
      t.belongs_to :participant, foreign_key: { on_delete: :cascade }
      t.string :status, limit: 16, required: true, default: 'draft'

      t.timestamps

      t.index %i[status participant_id]
    end
  end
end
