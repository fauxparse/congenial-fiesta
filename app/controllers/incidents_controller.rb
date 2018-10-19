# frozen_string_literal: true

class IncidentsController < ApplicationController
  def new
    @incident = festival.incidents.build
  end

  def create
    render :new unless incident.save
  end

  private

  def incident_params
    params.require(:incident).permit(:description, :anonymous)
  end

  def incident
    @incident ||= festival.incidents.build(incident_params).tap do |incident|
      incident.participant = current_participant unless incident.anonymous?
    end
  end

  helper_method :incident
end
