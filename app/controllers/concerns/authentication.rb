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

    def must_be_logged_out(*options)
      before_action :require_no_authentication, *options
    end
  end

  private

  def current_participant
    @current_participant ||= Participant.find_by(id: session[:participant])
  end

  alias current_user current_participant

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
    store_location
    redirect_to(*url)
  end

  def store_location(location = request.path)
    session[:redirect] = location
  end

  def require_authentication
    store_and_redirect_to(login_path) unless logged_in?
  end

  def require_no_authentication
    redirect_to(root_path) if logged_in?
  end
end
