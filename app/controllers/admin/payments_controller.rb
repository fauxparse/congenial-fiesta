# frozen_string_literal: true

module Admin
  class PaymentsController < Controller
    def index
      authorize Payment, :update?
    end

    def show
      authorize payment, :update?
      render_payment
    end

    def update
      authorize payment, :update?
      payment.update!(payment_params)
      render_payment
    end

    private

    def payment_params
      params.require(:payment).permit(:state)
    end

    def payments
      @payments ||= Payments.new(festival, params)
    end

    def payment
      @payment ||= festival.payments.find_by_hashid(params[:id])
    end

    def render_payment
      respond_to do |format|
        format.json { render json: PaymentSerializer.new(payment).call }
      end
    end

    helper_method :payments
  end
end
