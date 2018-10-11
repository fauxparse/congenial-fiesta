# frozen_string_literal: true

class CreateVouchers < ActiveRecord::Migration[5.2]
  def change
    create_table :vouchers do |t|
      t.belongs_to :registration, foreign_key: { on_delete: :cascade }
      t.integer :workshop_count, default: 1
      t.text :note

      t.timestamps
    end
  end
end
