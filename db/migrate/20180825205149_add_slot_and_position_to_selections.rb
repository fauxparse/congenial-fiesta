# frozen_string_literal: true

class AddSlotAndPositionToSelections < ActiveRecord::Migration[5.2]
  def up
    add_column :selections, :slot, :string
    add_column :selections, :position, :integer, default: 1
    add_index :selections, %i[registration_id slot position]

    # migrate_existing_preferences
  end

  def down
    # remove_newly_created_selections

    remove_column :selections, :slot
    remove_column :selections, :position
  end

  private

  def migrate_existing_preferences
    Preference.all.each do |preference|
      Selection.create!(preference.attributes.except(:id))
    end
  end

  def remove_newly_created_selections
    Preference.all.each do |preference|
      selection = Selection.find_by(
        registration_id: preference.registration_id,
        schedule_id: preference.schedule_id
      )
      selection&.destroy
    end
  end
end
