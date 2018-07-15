# frozen_string_literal: true

class Activity < ApplicationRecord
  include Sluggable

  belongs_to :festival
  belongs_to :pitch, optional: true
  has_many :presenters
  has_many :schedules

  validates :name, :type, presence: true

  scope :with_presenters, -> { includes(presenters: :participant) }
end

require_dependency 'workshop'
require_dependency 'show'
