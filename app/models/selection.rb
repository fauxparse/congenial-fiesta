# frozen_string_literal: true

class Selection < ApplicationRecord
  TIME_TO_COMPLETE_REGISTRATION = 5.minutes

  belongs_to :registration
  belongs_to :schedule
  has_one :activity, through: :schedule
  has_one :participant, through: :registration

  acts_as_list scope: %i[registration_id slot]

  enum state: {
    pending: 'pending',
    registered: 'registered',
    allocated: 'allocated'
  }

  before_validation :populate_slot
  after_destroy :check_waitlist

  validates :registration_id, :schedule_id, :slot, presence: true
  validates :schedule_id, uniqueness: { scope: :registration_id }

  scope :sorted, -> { order(:position) }
  scope :excluded, -> { where(excluded: true) }

  def slot
    super || populate_slot
  end

  def <=>(other)
    position <=> other.position
  end

  def self.with_activity
    includes(schedule: :activity)
      .references(:activity)
  end

  def self.included_in_limit
    with_activity
      .where(
        'selections.state = ? OR ' \
        '(selections.state = ? AND selections.updated_at > ?)',
        :allocated,
        :pending,
        Time.zone.now - TIME_TO_COMPLETE_REGISTRATION
      )
      .merge(Schedule.not_freebie)
  end

  private

  def populate_slot
    self.slot = schedule&.slot
  end

  def check_waitlist
    CheckWaitlist.new(schedule).call
  end
end
