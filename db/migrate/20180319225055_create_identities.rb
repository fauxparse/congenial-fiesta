# frozen_string_literal: true

class CreateIdentities < ActiveRecord::Migration[5.2]
  def change
    create_table :identities do |t|
      t.belongs_to :participant,
        required: true,
        foreign_key: { on_delete: :cascade }
      t.string :type, required: true
      t.string :provider, limit: 64
      t.string :uuid, limit: 64
      t.string :password_digest

      t.timestamps

      t.index %i[participant_id type provider], unique: true
      t.index %i[provider uuid], unique: true
    end
  end
end
