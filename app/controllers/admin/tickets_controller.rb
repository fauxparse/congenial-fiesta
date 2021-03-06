# frozen_string_literal: true

module Admin
  class TicketsController < Controller
    skip_before_action :require_admin

    after_action :verify_authorized

    def index
      authorize Show, :index?, policy_class: ShowPolicy
    end

    def show
      raise ActiveRecord::NotFound unless schedule.present?
      authorize schedule.activity, :show?, policy_class: ShowPolicy
    end

    private

    def shows
      @shows ||= scope.sorted.all
    end

    def schedule
      @schedule ||= scope.where('activities.slug = ?', params[:id]).first
    end

    def scope
      Schedule
        .with_details
        .references(:activities)
        .merge(Show.for_festival(festival))
    end

    def allocated_tickets
      schedule
        .selections
        .allocated
        .includes(:participant)
        .all
        .map(&:participant)
        .sort
    end

    def waitlist
      schedule
        .waitlists
        .includes(registration: :participant)
        .all
        .sort
        .map { |w| w.registration.participant }
    end

    helper_method :shows, :schedule, :allocated_tickets, :waitlist
  end
end
