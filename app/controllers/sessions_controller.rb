# frozen_string_literal: true

class SessionsController < ApplicationController
  layout 'login'

  skip_before_action :verify_authenticity_token, only: :oauth

  def new
    @login_form = LoginForm.new
  end

  def create
    if login_form.valid?
      log_in_and_redirect(login_form.participant)
    else
      render :new
    end
  end

  def oauth
    participant =
      ParticipantFromOauth.new(oauth_hash, current_participant).participant
    log_in_and_redirect(participant)
  end

  def destroy
    log_out
  end

  private

  def login_form
    @login_form ||= LoginForm.new(**credentials.to_h.symbolize_keys)
  end

  helper_method :login_form

  def credentials
    params.require(:login).permit(:email, :password)
  end

  def oauth_hash
    request.env['omniauth.auth']
  end
end
