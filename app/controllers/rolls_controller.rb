# frozen_string_literal: true

class RollsController < ApplicationController
  def show
    authorize workshop, policy_class: WorkshopPolicy
  end

  private

  def workshop
    festival.workshops.find_by(slug: params[:id])
  end

  def rolls
    workshop.schedules.sort_by(&:starts_at).map { |s| Roll.new(s) }
  end

  helper_method :workshop, :rolls
end
