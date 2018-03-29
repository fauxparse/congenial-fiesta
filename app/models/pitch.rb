# frozen_string_literal: true

class Pitch < ApplicationRecord
  belongs_to :participant

  enum status: {
    draft: 'draft',
    submitted: 'submitted',
    accepted: 'accepted',
    declined: 'declined'
  }

  serialize :info, Pitch::Info
end
