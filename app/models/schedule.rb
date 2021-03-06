# frozen_string_literal: true

class Schedule < ApplicationRecord
  belongs_to :activity
  belongs_to :venue, optional: true
  has_many :selections, dependent: :destroy
  has_one :festival, through: :activity
  has_many :presenters, through: :activity
  has_many :waitlists

  validates :starts_at, :ends_at, :activity_id, presence: true
  validates :ends_at, time: { after: :starts_at }

  after_save :update_selection_slots

  scope :sorted, -> { order(:starts_at, :id) }
  scope :freebie, -> { where(freebie: true) }
  scope :not_freebie, -> { where(freebie: false) }
  scope :with_details, -> { includes(activity: { presenters: :participant }) }
  scope :with_selections,
    -> { includes(selections: { registration: :participant }) }

  def <=>(other)
    starts_at <=> other.starts_at
  end

  def slot
    starts_at.to_i.to_s
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

  private

  def update_selection_slots
    selections.update_all(slot: slot) if previous_changes.include?(:starts_at)
  end
end
