# frozen_string_literal: true

class CreatePresenters < ActiveRecord::Migration[5.2]
  def change
    create_table :presenters do |t|
      t.belongs_to :activity, foreign_key: true
      t.belongs_to :participant, foreign_key: true

      t.index %i[activity_id participant_id], unique: true
    end

    change_table :participants do |t|
      t.string :company
      t.string :city
      t.string :country_code
      t.text :bio
    end
  end
end
