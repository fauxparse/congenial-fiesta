# frozen_string_literal: true

class NewPitch
  attr_reader :festival, :participant

  def initialize(festival, participant)
    @festival = festival
    @participant = participant
  end

  def pitch
    @pitch ||= festival.pitches.new do |pitch|
      pitch.participant = participant
      pitch.info.presenter = presenter_info
    end
  end

  private

  def previous_pitch
    @previous_pitch ||= participant.pitches.to(festival).newest_first.first
  end

  def presenter_info
    previous_pitch&.info&.presenter || {}
  end
end
