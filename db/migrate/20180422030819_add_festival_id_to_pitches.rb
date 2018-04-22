# frozen_string_literal: true

class AddFestivalIdToPitches < ActiveRecord::Migration[5.2]
  def change
    change_table :pitches do |t|
      t.belongs_to :festival, foreign_key: { on_delete: :cascade }
      t.index %i[festival_id participant_id]
    end
  end
end
