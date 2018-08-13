# frozen_string_literal: true

class AddCodeOfConductAcceptanceToRegistrations < ActiveRecord::Migration[5.2]
  def change
    add_column :registrations, :code_of_conduct_accepted_at, :timestamp
  end
end
