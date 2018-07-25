# frozen_string_literal: true

module Admin
  class ActivitiesController < Controller
    def index
      authorize Activity, :index?
      respond_to do |format|
        format.json { render json: serialized_activities }
        format.html
      end
    end

    def create
      activity = festival.activities.build(activity_params)
      authorize activity, :create?
      activity.save
      respond_to do |format|
        format.json { respond_with(activity) }
      end
    end

    private

    def activity_params
      params.require(:activity).permit(:name, :type)
    end

    def respond_with(activity)
      if activity.errors.empty?
        render json: ActivitySerializer.new(activity).call
      else
        render(
          json: activity.as_json.merge(errors: activity.errors.to_hash(true)),
          status: :unprocessable_entity
        )
      end
    end

    def serialized_activities
      ActivitiesSerializer.new(
        activities: festival.activities.with_presenters.all,
        activity_types: Activity.subclasses
      ).call
    end
  end
end
