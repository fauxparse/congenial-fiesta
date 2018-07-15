# frozen_string_literal: true

module Admin
  class VenuesController < Controller
    def index
      respond_to do |format|
        format.html
        format.json do
          render json: VenuesSerializer.new(venues: Venue.all).call
        end
      end
    end
  end
end
