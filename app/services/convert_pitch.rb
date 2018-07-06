# frozen_string_literal: true

class ConvertPitch
  attr_reader :pitch

  def initialize(pitch)
    @pitch = pitch
  end

  def call
    pitch.transaction do
      pitch_converter.call
    end
  end

  private

  def pitch_converter_class
    self.class.const_get(pitch.info.activity.type.camelize)
  end

  def pitch_converter
    pitch_converter_class.new(pitch)
  end
end
