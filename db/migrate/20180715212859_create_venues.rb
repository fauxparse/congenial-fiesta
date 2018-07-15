# frozen_string_literal: true

class CreateVenues < ActiveRecord::Migration[5.2]
  def change
    create_table :venues do |t|
      t.string :name, required: true
      t.string :address, required: true
      t.decimal :latitude, precision: 15, scale: 10, required: true
      t.decimal :longitude, precision: 15, scale: 10, required: true

      t.index %i[latitude longitude]
    end
  end
end
