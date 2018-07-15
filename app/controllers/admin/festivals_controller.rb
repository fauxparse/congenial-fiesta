# frozen_string_literal: true

module Admin
  class FestivalsController < Controller
    def index
      redirect_to admin_festival_path(festival) if festival.present?
    end

    def show; end

    def new
      @festival = Festival.new(default_dates)
    end

    def create
      @festival = Festival.new(festival_params)
      if @festival.save
        redirect_to admin_festival_path(@festival)
      else
        render :new
      end
    end

    private

    def festival_params
      return {} unless params[:festival].present?
      params.require(:festival).permit(:year, :start_date, :end_date)
    end

    def default_dates
      year = Time.zone.today.year
      october = Date.new(year, 10, 14)
      start = october + 6 - october.wday
      { year: year, start_date: start, end_date: start + 7 }
    end
  end
end
