# frozen_string_literal: true

module Admin
  class SchedulesController < Controller
    def index
      authorize Schedule, :index?
      respond_to do |format|
        format.json { render json: serialized_timetable }
        format.html
      end
    end

    def show
      schedule = festival.schedules.find(params[:id])
      authorize schedule, :show?
      respond_to do |format|
        format.json { render_schedule(schedule) }
      end
    end

    def create
      schedule = Schedule.new(schedule_params)
      authorize schedule, :create?
      schedule.save!
      render_schedule(schedule)
    end

    def update
      schedule = festival.schedules.find(params[:id])
      authorize schedule, :update?
      schedule.update!(schedule_params)
      render_schedule(schedule)
    end

    def destroy
      schedule = festival.schedules.find(params[:id])
      authorize schedule, :destroy?
      schedule.destroy
      render_schedule(schedule)
    end

    private

    def schedule_params
      params
        .require(:schedule)
        .permit(:activity_id, :venue_id, :starts_at, :ends_at, :maximum)
    end

    def schedules
      festival.schedules.all
    end

    def render_schedule(schedule)
      respond_to do |format|
        format.json do
          render json: ScheduleSerializer.new(schedule).call
        end
      end
    end

    def serialized_timetable
      TimetableSerializer.new(
        schedules: schedules,
        activities: festival.activities.with_presenters.all,
        activity_types: Activity.subclasses,
        venues: Venue.all
      ).call
    end
  end
end
