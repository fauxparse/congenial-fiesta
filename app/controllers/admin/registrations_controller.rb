# frozen_string_literal: true

module Admin
  class RegistrationsController < Controller
    def index
      authorize festival
      respond_to do |format|
        format.json do
          render json: RegistrationSummarySerializer.new(festival).call
        end
      end
    end
  end
end
