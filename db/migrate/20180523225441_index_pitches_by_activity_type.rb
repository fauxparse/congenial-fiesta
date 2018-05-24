# frozen_string_literal: true

class IndexPitchesByActivityType < ActiveRecord::Migration[5.2]
  def up
    change_column :pitches, :info, :jsonb
    add_index :pitches,
      "(info->'activity'->>'type')",
      name: :by_activity_type
  end

  def down
    remove_index :pitches, name: :by_activity_type
    change_column :pitches, :info, :json
  end
end
