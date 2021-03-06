# frozen_string_literal: true

class Presenter < ApplicationRecord
  belongs_to :activity
  belongs_to :participant

  validates :activity_id, :participant_id, presence: true
  validates :participant_id, uniqueness: { scope: :activity_id }

  def to_s
    "#{participant.name}#{" (#{location})" unless location.blank?}"
  end

  def location
    @location ||= abbreviated_location(participant.country_code)
  end

  private

  def abbreviated_location(code)
    if code.blank?
      ''
    elsif code == 'nz'
      participant.city || 'NZ'
    else
      I18n.t(
        participant.country_code&.downcase,
        scope: :countries,
        default: participant.country
      )
    end
  end
end
