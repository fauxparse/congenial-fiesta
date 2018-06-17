# frozen_string_literal: true

class Pitch < ApplicationRecord
  include Hashid::Rails

  belongs_to :participant
  belongs_to :festival

  enum status: {
    draft: 'draft',
    submitted: 'submitted',
    accepted: 'accepted',
    declined: 'declined'
  }

  enum pile: {
    unsorted: 'unsorted',
    no: 'no',
    maybe: 'maybe',
    yes: 'yes'
  }

  serialize :info, Pitch::Info

  scope :newest_first, -> { order(created_at: :desc) }
  scope :to, ->(festival) { where(festival: festival) }
  scope :type, ->(type) { where("info->'activity'->>'type' = ?", type) }
end
