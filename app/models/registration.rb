# frozen_string_literal: true

class Registration < ApplicationRecord
  include Hashid::Rails

  belongs_to :festival
  belongs_to :participant
  has_many :selections, -> { sorted }, dependent: :destroy, autosave: true
  has_many :payments, dependent: :destroy, autosave: true
  has_many :waitlists, dependent: :destroy, autosave: true
  has_many :vouchers

  enum state: {
    pending: 'pending',
    awaiting_payment: 'awaiting_payment',
    confirmed: 'confirmed'
  }

  scope :completed, -> { where.not(completed_at: nil) }

  def workshops_saved?
    workshops_saved_at.present?
  end

  def shows_saved?
    shows_saved_at.present?
  end

  def completed?
    completed_at.present?
  end

  def self.with_full_details
    includes(
      :waitlists,
      selections: {
        schedule: [
          :venue,
          activity: {
            presenters: :participant
          }
        ]
      }
    )
  end
end
