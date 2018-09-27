# frozen_string_literal: true

class CreateWaitlists < ActiveRecord::Migration[5.2]
  def change
    create_table :waitlists do |t|
      t.belongs_to :schedule, foreign_key: { on_delete: :cascade }
      t.belongs_to :registration, foreign_key: { on_delete: :cascade }
      t.integer :position, default: 1

      t.timestamps
    end
  end
end
