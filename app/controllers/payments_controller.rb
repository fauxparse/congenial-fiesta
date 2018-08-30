# frozen_string_literal: true

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def paypal_callback
    payment.payment_method.process!(params.permit!)
    head :ok
  end

  def paypal_redirect
    redirect_to registration_step_path(:payment)
  end

  private

  def payment
    @payment ||= Payment.includes(:registration).find(params[:id])
  end
end
