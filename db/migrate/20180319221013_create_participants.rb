# frozen_string_literal: true

class CreateParticipants < ActiveRecord::Migration[5.2]
  def change
    create_table :participants do |t|
      t.string :name
      t.string :email

      t.timestamps

      t.index :email, unique: true
    end
  end
end
