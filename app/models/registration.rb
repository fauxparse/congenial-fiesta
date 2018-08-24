# frozen_string_literal: true

class Registration < ApplicationRecord
  include Hashid::Rails

  belongs_to :festival
  belongs_to :participant
  has_many :preferences, -> { sorted }, dependent: :destroy, autosave: true
  has_many :selections, dependent: :destroy, autosave: true

  enum state: {
    pending: 'pending',
    awaiting_payment: 'awaiting_payment',
    confirmed: 'confirmed'
  }

  def workshop_preferences_saved?
    workshop_preferences_saved_at.present?
  end
end
