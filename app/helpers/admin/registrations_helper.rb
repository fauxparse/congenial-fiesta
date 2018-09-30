# frozen_string_literal: true

module Admin
  module RegistrationsHelper
    def registration_workshop_selector(registration)
      ActivitySelector.new(
        registration,
        scope: workshop_scope,
        max_per_slot: earlybird_registration?(registration) ? nil : 1
      )
    end

    def registration_show_selector(registration)
      ActivitySelector.new(
        registration,
        scope: Show,
        max_per_slot: 1,
        include_free: true
      )
    end

    private

    def workshop_scope
      Workshop
        .includes(:levels, :schedules)
        .references(:levels)
    end

    def earlybird_registration?(registration)
      RegistrationStage.new(registration.festival).earlybird?
    end
  end
end
