# frozen_string_literal: true

class RegistrationsController < ApplicationController
  before_action :registrations_closed, unless: :registrations_open?

  def edit
    authorize registration, :edit?
  end

  def update
    authorize registration, :update?
    registration_form
      .on(:advance) { |step| redirect_to registration_step_path(step) }
      .on(:completed) { default_redirect_to complete_registration_path }
      .on(:show) { render :edit }
      .on(:login) { |participant| log_in_as(participant) }
      .on(:redirect) { |url| redirect_to(url) }
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

  def registrations
    @registrations ||= RegistrationStage.new(festival)
  end

  delegate :open?, to: :registrations, prefix: true

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

  def registrations_closed
    redirect_to root_path, info: I18n.t('registrations.closed')
  end

  def default_redirect_to(url)
    redirect_to url unless performed?
  end

  helper_method :registration_form
end
