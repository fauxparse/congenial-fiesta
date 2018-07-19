# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimetableSerializer, type: :serializer do
  subject(:serializer) do
    TimetableSerializer.new(
      schedules: festival.schedules.all,
      activities: festival.activities.all,
      activity_types: Activity.subclasses,
      venues: Venue.all
    )
  end
  let!(:schedule) do
    activity.schedules.create!(
      starts_at: start_time,
      ends_at: end_time,
      venue: venue
    )
  end
  let(:activity) { create(:workshop) }
  let(:festival) { activity.festival }
  let(:venue) { create(:venue) }
  let(:start_time) { festival.start_date.midnight.change(hour: 10) }
  let(:end_time) { start_time + 3.hours }
  let(:json) { serializer.call }

  it 'represents the object' do
    expect(json).to match(
      schedules: a_collection_containing_exactly(
        id: schedule.id,
        venue_id: venue.id,
        activity_id: activity.id,
        starts_at: start_time,
        ends_at: end_time
      ),
      activities: a_collection_containing_exactly(
        id: activity.id,
        name: activity.name,
        type: 'Workshop',
        presenters: []
      ),
      activity_types: a_collection_containing_exactly(
        { name: 'Workshop', label: 'Workshop' },
        name: 'Show', label: 'Show'
      ),
      venues: a_collection_containing_exactly(
        id: venue.id,
        name: venue.name,
        address: venue.address,
        latitude: venue.latitude,
        longitude: venue.longitude
      )
    )
  end
end
