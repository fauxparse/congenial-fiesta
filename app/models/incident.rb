# frozen_string_literal: true

class Incident < ApplicationRecord
  include Hashid::Rails

  belongs_to :festival
  belongs_to :participant, optional: true
  has_many :comments, -> { order(:created_at) }, as: :subject

  enum status: {
    open: 'open',
    closed: 'closed'
  }

  before_validation :anonymise, if: :anonymous?

  validates :description, presence: true
  validates :participant_id, absence: true, if: :anonymous?

  scope :anonymous, -> { where(participant_id: nil) }
  scope :newest_first, -> { order(created_at: :desc) }

  attr_accessor :anonymous

  def anonymous?
    anonymous.to_b
  end

  private

  def anonymise
    self.participant = nil
  end
end
