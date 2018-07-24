# frozen_string_literal: true

class Activity < ApplicationRecord
  include Sluggable

  belongs_to :festival
  belongs_to :pitch, optional: true
  has_many :presenters
  has_many :schedules

  validates :name, :type, :maximum, presence: true
  validates :maximum, numericality: { greater_than: 0, only_integer: true }

  scope :with_presenters, -> { includes(presenters: :participant) }

  def policy_class
    ActivityPolicy
  end
end

require_dependency 'workshop'
require_dependency 'show'
