# frozen_string_literal: true

class PitchesController < ApplicationController
  authenticate except: %i[new create]

  before_action :load_pitch, only: %i[edit update]

  def index; end

  def new
    store_location unless logged_in?
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
    if should_redirect?
      redirect_to_current_step
    else
      render_current_step
    end
  end

  def pitch_form
    @pitch_form ||= PitchForm.new(pitch, step: params[:step])
  end

  def current_step
    pitch_form.current_step
  end

  def should_redirect?
    (params[:step] && current_step.to_param != params[:step].to_sym) ||
      current_step.errors.empty?
  end

  def render_current_step
    current_step.errors.clear unless params[:submit].present?
    render :edit
  end

  def redirect_to_current_step
    redirect_to pitch_step_path(pitch, current_step)
  end

  def pitch
    @pitch ||=
      festival.pitches.new(participant: current_participant || Participant.new)
  end

  def festival
    @festival ||= Festival.current
  end

  def load_pitch
    @pitch = current_participant.pitches.find(params[:id])
  end

  def pitch_attributes
    pitch_form.current_step.permit(params.require(:pitch))
  end

  helper_method :pitch, :pitch_form
end
