# frozen_string_literal: true

module Admin
  class ReportsController < Controller
    def workshops
      authorize festival, :show?
      render_report WorkshopsReport.new(festival)
    end

    def washup
      authorize festival, :show?
      render_report WashupReport.new(festival)
    end

    def finance
      authorize festival, :show?
      render_report FinanceReport.new(festival)
    end

    def workshop_participation
      authorize festival, :show?
      render_report WorkshopParticipationReport.new(festival)
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
