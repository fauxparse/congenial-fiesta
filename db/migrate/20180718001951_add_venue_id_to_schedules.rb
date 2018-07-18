class AddVenueIdToSchedules < ActiveRecord::Migration[5.2]
  def change
    change_table :schedules do |t|
      t.belongs_to :venue, foreign_key: { on_delete: :nullify }, required: false
    end
  end
end
