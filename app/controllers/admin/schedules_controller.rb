# frozen_string_literal: true

module Admin
  class SchedulesController < Controller
    def index
      respond_to do |format|
        format.json do
          serializer = TimetableSerializer.new(
            schedules: schedules,
            activities: festival.activities.with_presenters.all
          )
          render json: serializer.call
        end
        format.html
      end
    end

    def show
      schedule = festival.schedules.find(params[:id])
      respond_to do |format|
        format.json { render_schedule(schedule) }
      end
    end

    def create
      schedule = Schedule.create!(schedule_params)
      render_schedule(schedule)
    end

    def update
      schedule = festival.schedules.find(params[:id])
      schedule.update!(schedule_params)
      render_schedule(schedule)
    end

    def destroy
      schedule = festival.schedules.find(params[:id])
      schedule.destroy
      render_schedule(schedule)
    end

    private

    def schedule_params
      params.require(:schedule).permit(:activity_id, :starts_at, :ends_at)
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
  end
end
