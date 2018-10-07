# frozen_string_literal: true

class ActivitiesController < ApplicationController
  def index; end

  def show; end

  private

  def activities
    @activities ||= ScheduledActivityList.new(festival, activity_type)
  end

  helper_method :activities

  def activity_type
    case params[:type]
    when Workshop then Workshop.includes(:levels)
    else params[:type].camelize.constantize
    end
  end

  def activity
    activities.find(params[:id])
  end

  helper_method :activity
end
