# frozen_string_literal: true

class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.html
    end
  end

  private

  def calendar
    @calendar ||= Calendar.new(festival, current_participant)
  end

  helper_method :calendar
end
