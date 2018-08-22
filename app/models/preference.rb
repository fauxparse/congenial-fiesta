# frozen_string_literal: true

class Preference < ApplicationRecord
  belongs_to :registration
  belongs_to :schedule

  acts_as_list scope: %i[registration_id slot]

  before_validation :update_slot

  validates :registration_id, :schedule_id, :slot, presence: true
  validates :schedule_id, uniqueness: { scope: :registration_id }

  scope :sorted, -> { order(:position) }

  private

  def update_slot
    self.slot = schedule&.slot
  end
end
