# frozen_string_literal: true

class CreatePasswordResets < ActiveRecord::Migration[5.2]
  def change
    create_table :password_resets do |t|
      t.belongs_to :participant, foreign_key: { on_delete: :cascade }
      t.string :token
      t.timestamp :created_at
      t.timestamp :expires_at

      t.index :token, unique: true
      t.index %i[token expires_at]
    end
  end
end
