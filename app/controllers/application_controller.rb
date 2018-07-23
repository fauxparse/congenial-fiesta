# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  include Pundit

  private

  def festival
    @festival ||= Festival.current
  end

  helper_method :festival
end
