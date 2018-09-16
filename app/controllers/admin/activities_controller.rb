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
      respond_to do |format|
        format.json { render json: ActivitySerializer.new(activity).call }
        format.html
      end
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
        updated_successfully
      else
        not_updated_successfully
      end
    end

    def dry_run
      authorize Activity, :update?
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
          :name, :type, :slug, :description, :maximum, :photo,
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

    def updated_successfully
      respond_to do |format|
        format.json { render json: ActivitySerializer.new(activity).call }
        format.html do
          redirect_to polymorphic_path([:admin, activity], year: festival),
            notice: I18n.t('admin.activities.update.success')
        end
      end
    end

    def not_updated_successfully
      respond_to do |format|
        format.json do
          head :unprocessable_entity
        end
        format.html do
          flash.now[:error] = I18n.t('admin.activities.update.error')
          render :show
        end
      end
    end

    def allocator
      @allocator ||= if params[:magic_number]
        AllocateWorkshops.with_magic_number(festival, params[:magic_number])
      else
        AllocateWorkshops.new(festival)
      end
    end

    def allocated_workshops
      @allocated_workshops ||= allocator.tap(&:call).results
    end

    helper_method :allocator, :allocated_workshops
  end
end
