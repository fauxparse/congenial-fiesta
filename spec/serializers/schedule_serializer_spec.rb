# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleSerializer, type: :serializer do
  subject(:serializer) { ScheduleSerializer.new(schedule) }
  let(:schedule) do
    activity.schedules.create(
      starts_at: start_time,
      ends_at: end_time,
      venue: venue
    )
  end
  let(:activity) { create(:workshop) }
  let(:venue) { create(:venue) }
  let(:start_time) { activity.festival.start_date.midnight.change(hour: 10) }
  let(:end_time) { start_time + 3.hours }
  let(:json) { serializer.call }

  it 'represents the object' do
    expect(json).to eq(
      id: schedule.id,
      venue_id: venue.id,
      activity_id: activity.id,
      starts_at: start_time,
      ends_at: end_time
    )
  end
end
