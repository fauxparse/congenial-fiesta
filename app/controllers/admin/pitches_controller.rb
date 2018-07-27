# frozen_string_literal: true

module Admin
  class PitchesController < Controller
    def index
      authorize Pitch, :index?
    end

    def show
      authorize pitch, :show?
    end

    def update
      authorize pitch, :update?
      pitch.update!(pitch_params)
      respond_to do |format|
        format.json { render json: PitchSerializer.new(pitch).call }
        format.html { redirect_to admin_pitch_path(pitch.festival, pitch) }
      end
    end

    private

    def pitch
      @pitch ||= festival.pitches.find_by_hashid!(params[:id])
    end

    def pitches
      @pitches ||= Pitches.new(festival, params)
    end

    def pitch_params
      params.require(:pitch).permit(:pile, :gender_list, :origin_list)
    end

    helper_method :pitch, :pitches
  end
end
