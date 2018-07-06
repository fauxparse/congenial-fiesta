# frozen_string_literal: true

class Activity < ApplicationRecord
  include Sluggable

  belongs_to :festival
  belongs_to :pitch, optional: true
  has_many :presenters

  validates :name, presence: true
end
