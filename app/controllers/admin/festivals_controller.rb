# frozen_string_literal: true

module Admin
  class FestivalsController < Controller
    def index
      redirect_to admin_festival_path(festival) if festival.present?
      authorize Festival.new, :create?
    end

    def show
      authorize festival
    end

    def new
      @festival = Festival.new(default_dates)
      authorize @festival, :create?
    end

    def create
      @festival = Festival.new(festival_params)
      authorize @festival, :create?
      if @festival.save
        redirect_to admin_festival_path(@festival)
      else
        render :new
      end
    end

    def edit
      authorize festival, :update?
    end

    def update
      authorize festival, :update?
      if festival.update_attributes(festival_params)
        redirect_to admin_festival_path(festival)
      else
        render :edit
      end
    end

    private

    def festival_params
      return {} unless params[:festival].present?
      params
        .require(:festival)
        .permit(
          :year,
          :start_date,
          :end_date,
          :registrations_open_at,
          :earlybird_cutoff
        )
    end

    def default_dates
      year = Time.zone.today.year
      october = Date.new(year, 10, 14)
      start = october + 6 - october.wday
      { year: year, start_date: start, end_date: start + 7 }
    end
  end
end
