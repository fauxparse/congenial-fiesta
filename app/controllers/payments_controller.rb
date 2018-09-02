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
      format.html { return_to_registration unless payment.pending? }
    end
  end

  private

  def payment
    @payment ||= Payment.includes(:registration).find(params[:id])
  end

  def return_to_registration
    flash[:error] = I18n.t('payment.problem') unless payment.approved?
    redirect_to registration_step_path(:payment)
  end
end
