# frozen_string_literal: true

class AddPileToPitches < ActiveRecord::Migration[5.2]
  def change
    change_table :pitches do |t|
      t.string :pile, required: true, default: 'unsorted', index: true
    end
  end
end
