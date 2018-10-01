# frozen_string_literal: true

class UpdateRegistration
  include ActivityAssignment

  attr_reader :registration, :workshop_preferences, :show_preferences

  def initialize(registration, params)
    @registration = registration
    @workshop_preferences = sanitize(params[:workshops])
    @show_preferences = sanitize(params[:shows])
  end

  def call
    registration.transaction do
      update_workshop_selections
      update_show_selections
      registration.save
    end
  end

  private

  delegate :festival, to: :registration

  def earlybird?
    true
  end

  def update_workshop_selections
    update_selections(workshop_preferences, type: Workshop)
  end

  def update_show_selections
    update_selections(show_preferences, type: Show)
  end

  def sanitize(hash)
    (hash || {}).transform_keys(&:to_i)
  end
end
