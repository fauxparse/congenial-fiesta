# frozen_string_literal: true

class Waitlist < ApplicationRecord
  belongs_to :schedule
  belongs_to :registration

  acts_as_list scope: :schedule

  validates :registration_id, uniqueness: { scope: :schedule_id }

  scope :in_order, -> { order(:position) }

  def <=>(other)
    position <=> other.position
  end
end
