# frozen_string_literal: true

module Admin
  class VenuesController < Controller
    def index
      respond_to do |format|
        format.json { render json: serialize_venues }
        format.html
      end
    end

    def create
      venue = Venue.create!(venue_params)
      respond_to do |format|
        format.json { render json: VenueSerializer.new(venue).call }
      end
    end

    def update
      venue = Venue.find(params[:id])
      venue.update!(venue_params)
      respond_to do |format|
        format.json { render json: VenueSerializer.new(venue).call }
      end
    end

    def destroy
      venue = Venue.find(params[:id])
      venue.destroy
      respond_to do |format|
        format.json { render json: VenueSerializer.new(venue).call }
      end
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
  end
end
