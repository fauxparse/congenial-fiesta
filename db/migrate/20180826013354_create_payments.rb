# frozen_string_literal: true

class CreatePayments < ActiveRecord::Migration[5.2]
  def change
    create_table :payments do |t|
      t.belongs_to :registration, foreign_key: { on_delete: :restrict }
      t.string :type
      t.integer :amount_cents, default: 0
      t.string :state, default: 'pending'
      t.string :reference
      t.json :details, required: true

      t.timestamps
    end
  end
end
