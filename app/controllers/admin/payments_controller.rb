# frozen_string_literal: true

module Admin
  class PaymentsController < Controller
    def index
      authorize Payment, :update?
    end

    private

    def payments
      @payments ||= Payments.new(festival, params)
    end

    helper_method :payments
  end
end
