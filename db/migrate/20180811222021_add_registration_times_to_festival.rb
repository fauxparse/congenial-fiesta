# frozen_string_literal: true

class AddRegistrationTimesToFestival < ActiveRecord::Migration[5.2]
  def change
    change_table :festivals do |t|
      t.timestamp :registrations_open_at
      t.timestamp :earlybird_cutoff
    end
  end
end
