# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    @login_form = LoginForm.new
  end

  def create
    if login_form.valid?
      log_in_as(login_form.participant)
      redirect_to root_path
    else
      render :new
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def login_form
    @login_form ||= LoginForm.new(**credentials.to_h.symbolize_keys)
  end

  helper_method :login_form

  def credentials
    params.require(:login).permit(:email, :password)
  end

  def log_in_as(participant)
    session[:participant] = participant.id
  end

  def log_out
    session.delete(:participant)
  end
end
