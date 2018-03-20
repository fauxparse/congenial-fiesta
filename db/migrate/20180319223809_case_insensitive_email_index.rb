# frozen_string_literal: true

class CaseInsensitiveEmailIndex < ActiveRecord::Migration[5.2]
  def up
    remove_index :participants, :email
    execute <<~SQL
      CREATE UNIQUE INDEX index_participants_on_lowercase_email
      ON participants USING btree (lower(email));
    SQL
  end

  def down
    execute 'DROP INDEX index_participants_on_lowercase_email;'
    add_index :participants, :email, unique: true
  end
end
