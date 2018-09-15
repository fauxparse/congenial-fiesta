# frozen_string_literal: true

module Admin
  class ReportsController < Controller
    def workshops
      authorize festival, :show?
      render_report WorkshopsReport.new(festival)
    end

    private

    def render_report(report)
      respond_to do |format|
        format.csv { render_csv(report) }
        format.json { render json: report }
        format.html { render :show, locals: { report: report } }
      end
    end

    def render_csv(report)
      send_data report.to_csv,
        filename: "#{action_name}-#{Time.now.to_date}.csv"
    end
  end
end
