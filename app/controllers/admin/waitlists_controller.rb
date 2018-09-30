# frozen_string_literal: true

module Admin
  class WaitlistsController < Controller
    def show
      authorize activity
    end

    def update
      authorize activity

      Waitlist.acts_as_list_no_update do
        params[:waitlist].each_pair do |id, position|
          Waitlist.find(id).update!(position: position)
        end
      end

      head :no_content
    end

    private

    def slug
      params[:"#{params[:type].underscore}_id"]
    end

    def activity
      @activity =
        festival
          .activities
          .includes(schedules: { waitlists: { registration: :participant } })
          .references(:registration)
          .where(type: params[:type])
          .find_by(slug: slug)
    end

    helper_method :activity
  end
end
