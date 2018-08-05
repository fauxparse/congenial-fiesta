# frozen_string_literal: true

class AddMaximumToActivities < ActiveRecord::Migration[5.2]
  def change
    add_column :activities, :maximum, :integer, default: 16, required: true
  end
end
