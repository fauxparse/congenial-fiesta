# frozen_string_literal: true

class Presenter < ApplicationRecord
  include Nationalisable

  belongs_to :activity
  belongs_to :participant

  validates :activity_id, :participant_id, presence: true
  validates :participant_id, uniqueness: { scope: :activity_id }
end
