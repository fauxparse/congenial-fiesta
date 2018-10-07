# frozen_string_literal: true

module VenuesHelper
  def venue_link(venue, options = {})
    klass = class_string('venue__link', options[:class])
    return content_tag(:span, 'Venue TBC', class: klass) unless venue
    link_to(
      venue,
      google_maps_url(venue.latitude, venue.longitude),
      target: '_blank'
    )
  end

  private

  def google_maps_url(latitude, longitude)
    "https://maps.google.com/maps?daddr=#{latitude},#{longitude}&ll="
  end
end
