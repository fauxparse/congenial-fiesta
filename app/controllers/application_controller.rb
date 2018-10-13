# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Pundit

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    redirect_to root_path, notice: 'Sorry, you can’t view that page'
  end

  def festival
    @festival ||= Festival.current
  end

  helper_method :festival
end
