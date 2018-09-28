# frozen_string_literal: true

module Admin
  class AttendeesController < Controller
    def index
      authorize activity
    end

    private

    def slug
      params[:"#{params[:type].underscore}_id"]
    end

    def activity
      @activity =
        festival
          .activities
          .includes(schedules: { selections: :participant })
          .where(type: params[:type])
          .find_by(slug: slug)
    end

    helper_method :activity
  end
end
