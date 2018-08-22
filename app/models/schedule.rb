# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :activity
  belongs_to :venue, optional: true
  has_many :preferences, dependent: :destroy
  has_one :festival, through: :activity

  validates :starts_at, :ends_at, :activity_id, presence: true
  validates :ends_at, time: { after: :starts_at }

  scope :sorted, -> { order(:starts_at, :id) }

  def slot
    starts_at.to_i
  end
end
