class CreateIncidents < ActiveRecord::Migration[5.2]
  def change
    create_table :incidents do |t|
      t.belongs_to :festival, foreign_key: true
      t.belongs_to :participant, foreign_key: true, required: false
      t.text :description
      t.string :status, limit: 32, default: 'open'

      t.timestamps
    end
  end
end
