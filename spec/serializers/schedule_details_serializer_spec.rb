# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduleDetailsSerializer, type: :serializer do
  subject(:serializer) { ScheduleDetailsSerializer.new(schedule) }
  let(:schedule) do
    activity.schedules.create(
      starts_at: start_time,
      ends_at: end_time,
      venue: venue,
      maximum: 16
    )
  end
  let(:activity) do
    create(
      :workshop,
      description: 'a workshop',
      presenters: participants,
      level_list: %w[rookie intermediate]
    )
  end
  let(:participants) do
    [
      create(:participant, name: 'First', bio: 'Bio #1'),
      create(:participant, name: 'Second', bio: 'Bio #2')
    ]
  end
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
      ends_at: end_time,
      maximum: 16,
      name: 'A workshop',
      description: "<p>a workshop</p>\n",
      date: 'Saturday 20 October',
      times: '10:00AM–1:00PM',
      presenters: 'First and Second',
      bios: ["<p>Bio #1</p>\n", "<p>Bio #2</p>\n"],
      levels: %w[rookie intermediate]
    )
  end
end
