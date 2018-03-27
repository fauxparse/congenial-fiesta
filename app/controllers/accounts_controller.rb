# frozen_string_literal: true

class AccountsController < ApplicationController
  layout 'login'

  must_be_logged_out

  def new; end

  def create
    if signup_form.save
      log_in_and_redirect(signup_form.participant)
    else
      render :new
    end
  end

  private

  def attributes
    return {} unless params.key?(:participant)
    params
      .require(:participant)
      .permit(:name, :email, :password, :password_confirmation)
  end

  def signup_form
    @signup_form ||= SignupForm.new(attributes)
  end

  helper_method :signup_form
end
