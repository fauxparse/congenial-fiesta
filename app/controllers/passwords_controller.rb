# frozen_string_literal: true

class PasswordsController < ApplicationController
  def update
    if password_form.save
      log_in_as(password_form.participant) unless logged_in?
      redirect_to profile_path, notice: password_changed_message
    else
      render :edit
    end
  end

  private

  def password_params
    return {} unless params.include?(:password)
    params
      .require(:password)
      .permit(:password, :password_confirmation, :current_password, :token)
  end

  def password_form
    @password_form ||= PasswordForm.new(current_participant, password_params)
  end

  def password_changed_message
    password_form.existing_password? ? t('.changed') : t('.created')
  end

  helper_method :password_form
end
