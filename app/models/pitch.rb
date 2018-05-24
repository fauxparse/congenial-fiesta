# frozen_string_literal: true

class Pitch < ApplicationRecord
  belongs_to :participant
  belongs_to :festival

  enum status: {
    draft: 'draft',
    submitted: 'submitted',
    accepted: 'accepted',
    declined: 'declined'
  }

  serialize :info, Pitch::Info

  scope :newest_first, -> { order(created_at: :desc) }
  scope :to, ->(festival) { where(festival: festival) }
  scope :type, ->(type) { where("info->'activity'->>'type' = ?", type) }
end
