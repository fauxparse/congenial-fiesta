# frozen_string_literal: true

class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :participant, foreign_key: true
      t.belongs_to :subject, polymorphic: true
      t.text :text

      t.timestamps

      t.index %i[subject_id subject_type], unique: true
    end
  end
end
