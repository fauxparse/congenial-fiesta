# frozen_string_literal: true

class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.belongs_to :festival, foreign_key: { on_delete: :cascade }
      t.belongs_to :pitch, required: false
      t.string :type
      t.string :name
      t.string :slug
      t.text :description

      t.timestamps

      t.index %i[festival_id type slug], unique: true
    end
  end
end
