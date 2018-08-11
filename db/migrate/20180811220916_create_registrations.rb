# frozen_string_literal: true

class CreateRegistrations < ActiveRecord::Migration[5.2]
  def change
    create_table :registrations do |t|
      t.belongs_to :festival, foreign_key: { on_delete: :cascade }
      t.belongs_to :participant, foreign_key: { on_delete: :cascade }
      t.string :state, required: true, default: 'pending'

      t.timestamps

      t.index %i[festival_id participant_id], unique: true
      t.index %i[festival_id state]
    end
  end
end
