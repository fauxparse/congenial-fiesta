# frozen_string_literal: true

module Admin
  class IncidentsController < Controller
    def index
      authorize Incident
    end

    def show
      authorize incident
    end

    private

    def incidents
      @incidents ||=
        festival.incidents.includes(:participant).order('created_at DESC').all
    end

    def incident
      @incident ||= festival.incidents.find_by_hashid(params[:id])
    end

    helper_method :incident, :incidents
  end
end
