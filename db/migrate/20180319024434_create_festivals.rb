# frozen_string_literal: true

class CreateFestivals < ActiveRecord::Migration[5.2]
  def change
    create_table :festivals do |t|
      t.integer :year
      t.date :start_date
      t.date :end_date

      t.index :year, unique: true
    end
  end
end
