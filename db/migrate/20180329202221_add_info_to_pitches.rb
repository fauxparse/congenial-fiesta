# frozen_string_literal: true

class AddInfoToPitches < ActiveRecord::Migration[5.2]
  def change
    change_table :pitches do |t|
      t.json :info, required: true
    end
  end
end
