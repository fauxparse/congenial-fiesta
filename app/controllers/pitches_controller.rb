# frozen_string_literal: true

class PitchesController < ApplicationController
  authenticate except: %i[new create]

  before_action :load_pitch, only: %i[edit update]

  def index; end

  def new
    render :edit
  end

  def create
    update_pitch_form
  end

  def edit; end

  def update
    update_pitch_form
  end

  private

  def update_pitch_form
    current_step.attributes = pitch_attributes
    pitch_form.save!
    if current_step.errors.empty?
      redirect_to_current_step
    else
      render :edit
    end
  end

  def pitch_form
    @pitch_form ||= PitchForm.new(pitch, step: params[:step])
  end

  def current_step
    pitch_form.current_step
  end

  def redirect_to_current_step
    redirect_to pitch_step_path(pitch, current_step)
  end

  def pitch
    @pitch ||= Pitch.new(participant: current_participant || Participant.new)
  end

  def load_pitch
    @pitch = current_participant.pitches.find(params[:id])
  end

  def pitch_attributes
    pitch_form.current_step.permit(params.require(:pitch))
  end

  helper_method :pitch, :pitch_form
end
