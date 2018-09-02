# frozen_string_literal: true

class PaymentsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def paypal_callback
    payment.payment_method.process!(params.permit!)
    head :ok
  end

  def paypal_redirect
    respond_to do |format|
      format.json { render json: { state: payment.state } }
      format.html do
        redirect_to registration_step_path(:payment) unless payment.pending?
      end
    end
  end

  private

  def payment
    @payment ||= Payment.includes(:registration).find(params[:id])
  end
end
