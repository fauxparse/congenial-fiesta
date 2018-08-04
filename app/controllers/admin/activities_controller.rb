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

    def show
      authorize activity, :show?
    end

    def create
      @activity = festival.activities.build(activity_params)
      authorize activity, :create?
      activity.save
      respond_to do |format|
        format.json { respond_with(activity) }
      end
    end

    def update
      authorize activity, :update?
      if activity.update(activity_params)
        redirect_to polymorphic_path([:admin, activity], year: festival),
          notice: I18n.t('admin.activities.update.success')
      else
        flash.now[:error] = I18n.t('admin.activities.update.error')
        render :show
      end
    end

    private

    def activities
      @activities ||= Activities.new(festival, params.slice(:type))
    end
    helper_method :activities

    def activity_params
      params
        .require(:activity)
        .permit(
          :name,
          :type,
          :slug,
          :description,
          :maximum,
          presenter_participant_ids: [],
          level_list: []
        )
    end

    def activity
      @activity ||=
        festival
          .activities
          .with_presenters
          .where(type: params[:type])
          .find_by(slug: params[:id])
    end
    helper_method :activity

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
