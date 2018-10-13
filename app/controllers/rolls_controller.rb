# frozen_string_literal: true

class RollsController < ApplicationController
  authenticate

  before_action :check_presenter, only: :index

  def index
  end

  def show
    authorize workshop, policy_class: WorkshopPolicy
  end

  private

  def workshop
    festival.workshops.find_by(slug: params[:id])
  end

  def rolls(activity = workshop)
    activity.schedules.sort_by(&:starts_at).map { |s| Roll.new(s) }
  end

  def workshops
    @workshops ||=
      WorkshopPolicy::Scope.new(current_participant, festival).resolve
  end

  def check_presenter
    user_not_authorized unless workshops.any?
  end

  helper_method :workshop, :workshops, :rolls
end
