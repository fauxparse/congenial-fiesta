# frozen_string_literal: true

class PitchesController < ApplicationController
  authenticate except: %i[new create]

  before_action :check_pitches_open, only: %i[new create edit update]
  before_action :load_pitch, only: %i[edit update destroy]

  def index; end

  def new
    store_location unless logged_in?
    render :edit
  end

  def create
    update_pitch_form
    log_in_as pitch.participant unless logged_in?
  end

  def edit
    redirect_to_current_step unless params.include?(:step)
  end

  def update
    update_pitch_form
  end

  def destroy
    current_participant.pitches.draft.find_by_hashid!(params[:id]).destroy
    redirect_to pitches_path
  end

  private

  def check_pitches_open
    redirect_to root_path unless festival.pitches_open?
  end

  def update_pitch_form
    current_step.attributes = pitch_attributes
    pitch_form.save!
    if params[:submit] == 'save'
      redirect_to pitches_path
    elsif should_redirect?
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
    if pitch.draft?
      redirect_to pitch_step_path(pitch, current_step)
    else
      redirect_to pitches_path
    end
  end

  def pitch
    @pitch ||= new_pitch
  end

  def new_pitch
    NewPitch.new(festival, current_participant || Participant.new).pitch
  end

  def pitches
    @pitches ||=
      festival.pitches.from_participant(current_participant).newest_first
  end

  def load_pitch
    @pitch = current_participant.pitches.find_by_hashid!(params[:id])
  end

  def pitch_attributes
    return {} unless params.include?(:pitch)
    pitch_form.current_step.permit(params.require(:pitch))
  end

  helper_method :pitch, :pitches, :pitch_form
end
