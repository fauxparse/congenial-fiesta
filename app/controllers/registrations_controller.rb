# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def edit
    authorize registration, :edit?
  end

  def update
    authorize registration, :update?
    registration_form
      .on(:advance) { |step| redirect_to registration_step_path(step) }
      .on(:completed) { redirect_to complete_registration_path }
      .on(:show) { render :edit }
      .on(:login) { |participant| log_in_as(participant) }
      .update(registration_attributes)
  end

  def complete
    redirect_to registration_path unless registration&.completed?
  end

  def cart
    registration_form.assign_attributes(registration_attributes)
    respond_to do |format|
      format.json do
        render json: CartSerializer.new(registration_form.cart).call
      end
    end
  end

  def oauth
    store_location(registration_path)
    redirect_to "/auth/#{params[:provider]}"
  end

  private

  def registration
    registration_form.registration
  end

  def registration_form
    @registration_form ||=
      RegistrationForm.new(festival, current_participant, step: params[:step])
  end

  def registration_attributes
    return {} unless params[:registration].present?
    params
      .require(:registration)
      .permit(*registration_form.permitted_attributes)
  end

  helper_method :registration_form
end
