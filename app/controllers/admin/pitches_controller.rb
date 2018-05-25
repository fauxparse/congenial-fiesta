# frozen_string_literal: true

module Admin
  class PitchesController < Controller
    def index; end

    private

    def pitches
      @pitches ||= Pitches.new(festival, params)
    end

    helper_method :pitches
  end
end
