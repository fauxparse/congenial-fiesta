# frozen_string_literal: true

class Preference < ApplicationRecord
  belongs_to :registration
  belongs_to :schedule
  has_one :activity, through: :schedule

  acts_as_list scope: %i[registration_id slot]

  validates :registration_id, :schedule_id, :slot, presence: true
  validates :schedule_id, uniqueness: { scope: :registration_id }

  scope :sorted, -> { order(:position) }

  def slot
    super || write_attribute(:slot, schedule&.slot)
  end
end
