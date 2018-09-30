# frozen_string_literal: false

class AddRegistrationsClosedToFestivals < ActiveRecord::Migration[5.2]
  def change
    add_column :festivals, :registrations_closed, :boolean, default: false
  end
end
