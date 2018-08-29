# frozen_string_literal: true

class SchedulesController < ApplicationController
  def show
    respond_to do |format|
      format.json { render json: ScheduleDetailsSerializer.new(schedule).call }
    end
  end

  private

  def schedule
    @schedule ||= Schedule.with_details.find(params[:id])
  end
end
