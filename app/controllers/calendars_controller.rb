# frozen_string_literal: true

class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.ics { render plain: calendar.to_ical }
      format.html
    end
  end

  private

  def calendar
    @calendar ||= Calendar.new(festival, calendar_participant)
  end

  def calendar_participant
    if params[:id]
      Participant.find_by_hashid(params[:id])
    else
      current_participant
    end
  end

  helper_method :calendar
end
