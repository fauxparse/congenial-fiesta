# frozen_string_literal: true

module Admin
  class FinancesController < Controller
    def show
      authorize festival
      respond_to do |format|
        format.json { render json: FinanceSerializer.new(finance_report).call }
      end
    end

    private

    def finance_report
      FinanceReport.new(festival)
    end
  end
end
