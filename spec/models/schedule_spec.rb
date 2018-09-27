# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Schedule, type: :model do
  subject(:schedule) do
    Schedule.new(
      activity: workshop,
      starts_at: festival.start_date.to_time + 13.hours,
      ends_at: festival.start_date.to_time + 16.hours
    )
  end
  let(:workshop) { create(:workshop, festival: festival) }
  let(:festival) { create(:festival) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:starts_at) }
  it { is_expected.to validate_presence_of(:ends_at) }
  it { is_expected.to validate_presence_of(:activity_id) }

  context 'when changing times' do
    let(:selection) { schedule.selections.create(registration: registration) }
    let(:registration) { create(:registration, festival: festival) }

    before { schedule.save }

    it 'updates its selections’ slots' do
      new_start = schedule.starts_at + 1.day
      new_end = new_start + 3.hours
      expect { schedule.update!(starts_at: new_start, ends_at: new_end) }
        .to change { schedule.slot }
        .and change { selection.reload.slot }
      expect(selection.slot).to eq(schedule.slot)
    end
  end
end
