# frozen_string_literal: true

class Pitch < ApplicationRecord
  include Hashid::Rails

  belongs_to :participant
  belongs_to :festival
  has_many :activities

  acts_as_taggable_on :gender, :origin

  def self.genders
    %w[men women mixed]
  end

  def self.origins
    %w[nz australia overseas]
  end

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
  scope :by_participant, lambda {
    includes(:participant)
      .references(:participant)
      .order(Arel.sql('UPPER(participants.name)'))
  }
  scope :to, ->(festival) { where(festival: festival) }
  scope :from_participant, ->(participant) { where(participant: participant) }
  scope :type, ->(type) { where("info->'activity'->>'type' = ?", type) }
end
