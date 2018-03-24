# frozen_string_literal: true

class PasswordsController < ApplicationController
  before_action :complain_about_invalid_token,
    unless: :participant,
    only: %i[update reset]

  def new; end

  def create
    ResetPassword.new(params[:email]).call
  end

  def edit; end

  def update
    if participant.present? && password_form.save
      redirect_after_password_change
    else
      render :edit
    end
  end

  def reset
    render :edit
  end

  private

  def redirect_after_password_change
    log_in_as(password_form.participant) unless logged_in?
    redirect_to profile_path, notice: password_changed_message
  end

  def complain_about_invalid_token
    render :invalid unless participant.present?
  end

  def password_params
    return {} unless params.include?(:password)
    params
      .require(:password)
      .permit(:password, :password_confirmation, :current_password, :token)
  end

  def password_form
    @password_form ||=
      PasswordForm.new(participant, password_params, token: token)
  end

  def participant
    @participant ||=
      if token.present?
        PasswordReset.active.find_by(token: token)&.participant
      else
        current_participant
      end
  end

  def token
    @token ||= params[:token] || password_params[:token]
  end

  def password_changed_message
    password_form.existing_password? ? t('.changed') : t('.created')
  end

  helper_method :password_form
end
