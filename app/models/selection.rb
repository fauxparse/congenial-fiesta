# frozen_string_literal: true

class Selection < ApplicationRecord
  TIME_TO_COMPLETE_REGISTRATION = 5.minutes

  belongs_to :registration
  belongs_to :schedule

  enum state: {
    pending: 'pending',
    confirmed: 'confirmed'
  }

  validates :registration_id, :schedule_id, presence: true
  validates :schedule_id, uniqueness: { scope: :registration_id }

  def self.included_in_limit
    where(
      'state = ? OR updated_at > ?',
      :confirmed,
      Time.zone.now - TIME_TO_COMPLETE_REGISTRATION
    )
  end
end
