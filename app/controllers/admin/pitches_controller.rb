# frozen_string_literal: true

module Admin
  class PitchesController < Controller
    def index; end

    def show; end

    private

    def pitch
      @pitch ||= festival.pitches.find(params[:id])
    end

    def pitches
      @pitches ||= Pitches.new(festival, params)
    end

    helper_method :pitch, :pitches
  end
end
