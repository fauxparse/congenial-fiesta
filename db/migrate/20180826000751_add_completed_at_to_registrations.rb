# frozen_string_literal: true

class AddCompletedAtToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :completed_at, :timestamp
  end
end
