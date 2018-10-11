# frozen_string_literal: true

class Voucher < ApplicationRecord
  belongs_to :registration

  validates :workshop_count, :note, presence: true
  validates :workshop_count, numericality: { greater_than: 0 }
end
