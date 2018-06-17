# frozen_string_literal: true

module Admin
  class PitchesController < Controller
    def index; end

    def show; end

    def update
      pitch.update!(pitch_params)
      redirect_to admin_pitches_path
    end

    private

    def pitch
      @pitch ||= festival.pitches.find_by_hashid!(params[:id])
    end

    def pitches
      @pitches ||= Pitches.new(festival, params)
    end

    def pitch_params
      params.require(:pitch).permit(:pile)
    end

    helper_method :pitch, :pitches
  end
end
