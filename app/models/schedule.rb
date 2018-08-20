# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :activity
  belongs_to :venue, optional: true
  has_one :festival, through: :activity

  validates :starts_at, :ends_at, :activity_id, presence: true
  validates :ends_at, time: { after: :starts_at }

  scope :sorted, -> { order(:starts_at, :id) }
end
