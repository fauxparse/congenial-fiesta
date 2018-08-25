# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :activity
  belongs_to :venue, optional: true
  has_many :preferences, dependent: :destroy
  has_many :selections, dependent: :destroy
  has_one :festival, through: :activity

  validates :starts_at, :ends_at, :activity_id, presence: true
  validates :ends_at, time: { after: :starts_at }

  scope :sorted, -> { order(:starts_at, :id) }
  scope :freebie, -> { where(freebie: true) }
  scope :not_freebie, -> { where(freebie: false) }

  def slot
    starts_at.to_i
  end

  def active_selection_count
    selections.included_in_limit.count
  end

  def available?
    !maximum? || active_selection_count < maximum
  end

  def limited?
    maximum.present?
  end

  alias limited limited?

  def limited=(value)
    self.maximum = value.to_b ? maximum || activity.maximum : nil
  end
end
