# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::SchedulesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }
  let(:venue) { create(:venue) }
  let(:workshop) do
    create(:workshop, festival: festival).tap do |activity|
      create(:presenter, activity: activity)
    end
  end
  let(:schedule) do
    workshop.schedules.create(
      starts_at: start_time,
      ends_at: end_time,
      venue: venue
    )
  end
  let(:start_time) { festival.start_date.midnight.change(hour: 10) }
  let(:end_time) { start_time + 3.hours }
  let(:json) { JSON.parse(response.body).deep_symbolize_keys }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/timetable' do
    context 'as HTML' do
      before { get admin_timetable_path(festival) }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'as JSON' do
      before do
        workshop
        get admin_timetable_path(festival, format: :json)
      end

      it 'is successful' do
        expect(response).to be_successful
      end

      it 'has all the right stuff' do
        expect(json.keys)
          .to contain_exactly(:schedules, :activities, :activity_types, :venues)
      end
    end
  end

  describe 'GET /admin/:year/schedules/:id' do
    context 'as JSON' do
      before do
        get admin_schedule_path(festival, schedule, format: :json)
      end

      it 'looks right' do
        expect(json).to eq(
          id: schedule.id,
          activity_id: workshop.id,
          venue_id: venue.id,
          starts_at: schedule.starts_at.iso8601,
          ends_at: schedule.ends_at.iso8601,
          maximum: nil
        )
      end
    end
  end

  describe 'POST /admin/:year/schedules' do
    context 'as JSON' do
      let(:params) do
        {
          schedule: {
            starts_at: start_time,
            ends_at: end_time,
            venue_id: venue.id,
            activity_id: workshop.id,
            maximum: 12
          }
        }
      end

      def do_create
        post admin_schedules_path(festival, format: :json), params: params
      end

      it 'creates a schedule' do
        expect { do_create }.to change(Schedule, :count).by(1)
      end

      it 'returns the schedule' do
        do_create
        expect(json.except(:id)).to eq(
          activity_id: workshop.id,
          venue_id: venue.id,
          starts_at: start_time.iso8601,
          ends_at: end_time.iso8601,
          maximum: 12
        )
      end
    end
  end

  describe 'PUT /admin/:year/schedules/:id' do
    context 'as JSON' do
      let(:params) do
        {
          schedule: {
            starts_at: start_time + 1.hour,
            ends_at: end_time + 1.hour
          }
        }
      end

      def do_update
        put admin_schedule_path(festival, schedule, format: :json),
          params: params
      end

      it 'updates the schedule' do
        expect { do_update }.to change { schedule.reload.starts_at }.by 1.hour
      end
    end
  end

  describe 'DELETE /admin/:year/schedules/:id' do
    context 'as JSON' do
      def do_delete
        delete admin_schedule_path(festival, schedule, format: :json)
      end

      it 'updates the schedule' do
        schedule
        expect { do_delete }.to change(Schedule, :count).by(-1)
      end
    end
  end
end
