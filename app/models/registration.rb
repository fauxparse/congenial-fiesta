# frozen_string_literal: true

class Registration < ApplicationRecord
  include Hashid::Rails

  belongs_to :festival
  belongs_to :participant

  enum state: {
    pending: 'pending',
    awaiting_payment: 'awaiting_payment',
    confirmed: 'confirmed'
  }
end
