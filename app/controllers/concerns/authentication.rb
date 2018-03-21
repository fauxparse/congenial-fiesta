# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_participant, :logged_in?
  end

  class_methods do
    def authenticate(*options)
      before_action :require_authentication, *options
    end
  end

  private

  def current_participant
    @current_participant ||= Participant.find_by(id: session[:participant])
  end

  def logged_in?
    current_participant.present?
  end

  def log_in_as(participant)
    session[:participant] = participant.id
  end

  def log_in_and_redirect(participant)
    log_in_as(participant)
    redirect_after_login
  end

  def log_out
    session.delete(:participant)
    redirect_to root_path
  end

  def redirect_after_login
    redirect_to session.delete(:redirect) || root_path(anchor: nil)
  end

  def store_and_redirect_to(*url)
    session[:redirect] = request.path
    redirect_to(*url)
  end

  def require_authentication
    store_and_redirect_to(login_path) unless logged_in?
  end
end
