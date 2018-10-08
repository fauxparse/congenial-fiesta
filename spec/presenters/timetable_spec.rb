# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Timetable, type: :presenter do
  subject(:timetable) { Timetable.new(festival) }
  let(:festival) do
    instance_double(
      'Festival',
      start_date: Date.new(2018, 10, 20),
      end_date: Date.new(2018, 10, 27)
    )
  end

  describe '#time_slots' do
    subject(:slots) { timetable.time_slots(festival.start_date) }

    it { is_expected.to have_exactly(68).items }

    it 'gives quarter-hour intervals' do
      expect(slots.first.last).to eq(slots.first.first + 15.minutes)
    end

    it 'extends until 2am' do
      expect(slots.to_a.last.last).to eq Time.zone.local(2018, 10, 21, 2)
    end

    it 'takes a block' do
      counter = 0
      expect { timetable.time_slots(festival.start_date) { counter += 1 } }
        .to change { counter }.by 68
    end
  end

  describe '#times' do
    subject(:times) { timetable.times(festival.start_date) }

    it { is_expected.to have_exactly(69).items } # nice

    it 'starts at 9am' do
      expect(times.first).to eq Time.zone.local(2018, 10, 20, 9)
    end

    it 'ends at 2am' do
      expect(times.last).to eq Time.zone.local(2018, 10, 21, 2)
    end
  end

  describe '#days' do
    subject(:days) { timetable.days.to_a }

    it { is_expected.to eq((festival.start_date..festival.end_date).to_a) }
  end
end
