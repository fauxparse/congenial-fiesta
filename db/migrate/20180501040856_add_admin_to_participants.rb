# frozen_string_literal: true

class AddAdminToParticipants < ActiveRecord::Migration[5.2]
  def change
    change_table :participants do |t|
      t.boolean :admin, default: false, required: true, index: true
    end
  end
end
