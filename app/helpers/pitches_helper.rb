# frozen_string_literal: true

module PitchesHelper
  def pitch_name(pitch)
    [pitch.info.activity.name, t('.unnamed', type: pitch_type(pitch).downcase)]
      .detect(&:present?)
  end

  def pitch_type(pitch)
    pitch.info.activity.type.humanize
  end

  def pitch_date(pitch)
    l(pitch.created_at, format: :long)
  end

  def pitch_status(pitch)
    pitch.status.humanize
  end
end
