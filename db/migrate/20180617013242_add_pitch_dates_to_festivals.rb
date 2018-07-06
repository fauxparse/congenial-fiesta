# frozen_string_literal: true

class AddPitchDatesToFestivals < ActiveRecord::Migration[5.2]
  def change
    add_column :festivals, :pitches_open_at, :timestamp
    add_column :festivals, :pitches_close_at, :timestamp
  end
end
