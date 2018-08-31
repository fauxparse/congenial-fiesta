# frozen_string_literal: true

class Activity < ApplicationRecord
  include Sluggable

  belongs_to :festival
  belongs_to :pitch, optional: true
  has_many :presenters, dependent: :destroy, autosave: true
  has_many :schedules, dependent: :destroy

  has_one_attached :photo

  validates :name, :type, :maximum, presence: true
  validates :maximum, numericality: { greater_than: 0, only_integer: true }

  scope :with_presenters, -> { includes(presenters: :participant) }
  scope :by_name, -> { order(:name) }

  def self.to_param
    name.underscore.pluralize.dasherize
  end

  def policy_class
    ActivityPolicy
  end

  def presenter_participant_ids=(ids)
    new_participants = Participant.find(ids.reject(&:blank?))
    new_ids = new_participants.map(&:id)
    presenters.each do |presenter|
      presenter.mark_for_destruction \
        unless new_ids.include?(presenter.participant_id)
    end
    (new_ids - presenters.map(&:participant_id)).each do |id|
      presenters.build(participant_id: id)
    end
  end
end

require_dependency 'workshop'
require_dependency 'show'
