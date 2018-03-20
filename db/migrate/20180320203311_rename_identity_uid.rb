# frozen_string_literal: true

class RenameIdentityUid < ActiveRecord::Migration[5.2]
  def change
    rename_column :identities, :uuid, :uid
  end
end
