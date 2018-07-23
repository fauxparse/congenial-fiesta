# frozen_string_literal: true

module Admin
  class VenuesController < Controller
    def index
      authorize Venue, :index?
      respond_to do |format|
        format.json { render json: serialize_venues }
        format.html
      end
    end

    def create
      @venue = Venue.new(venue_params)
      authorize venue, :create?
      venue.save!
      render_venue
    end

    def update
      authorize venue, :update?
      venue.update!(venue_params)
      render_venue
    end

    def destroy
      authorize venue, :destroy?
      venue.destroy
      render_venue
    end

    private

    def serialize_venues
      VenuesSerializer.new(venues: Venue.all, origin: Venue.origin).call
    end

    def venue_params
      params
        .require(:venue)
        .permit(:name, :address, :latitude, :longitude)
    end

    def venue
      @venue ||= Venue.find(params[:id])
    end

    def render_venue
      respond_to do |format|
        format.json { render json: VenueSerializer.new(venue).call }
      end
    end
  end
end
