# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :activity
  has_one :festival, through: :activity

  validates :starts_at, :ends_at, :activity_id, presence: true
  validates :activity_id, uniqueness: { scope: :starts_at }
  validates :ends_at, time: { after: :starts_at }
end
