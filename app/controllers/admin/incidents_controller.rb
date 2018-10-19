# frozen_string_literal: true

module Admin
  class IncidentsController < Controller
    def index
      authorize Incident
    end

    def show
      authorize incident
    end

    def close
      authorize incident, :update?
      incident.closed!
      redirect_to admin_incidents_path(festival)
    end

    def reopen
      authorize incident, :update?
      incident.open!
      redirect_to admin_incident_path(festival, incident)
    end

    def comments
      authorize incident, :update?
      @comment = incident.comments.build(comment_params)
      @comment.participant = current_participant

      if @comment.save
        redirect_to admin_incident_path(festival, incident)
      else
        render :show
      end
    end

    private

    def incidents
      @incidents ||= scope.order('created_at DESC').all
    end

    def incident
      @incident ||= scope.includes(:comments).find_by_hashid(params[:id])
    end

    def scope
      festival.incidents.includes(:participant)
    end

    def comment_params
      params.require(:comment).permit(:text)
    end

    helper_method :incident, :incidents
  end
end
