# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def edit
    authorize registration, :edit?
  end

  def update
    authorize registration, :update?
    registration_form
      .on(:advance) { |step| redirect_to registration_step_path(step) }
      .on(:completed) { render :complete }
      .on(:show) { render :edit }
      .update(registration_attributes)
  end

  def cart
    registration_form.assign_attributes(registration_attributes)
    respond_to do |format|
      format.json do
        render json: CartSerializer.new(registration_form.cart).call
      end
    end
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
