# frozen_string_literal: true

class AddExcludedToSelections < ActiveRecord::Migration[5.2]
  def change
    add_column :selections, :excluded, :boolean, default: false
  end
end
