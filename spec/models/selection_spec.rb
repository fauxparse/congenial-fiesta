# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Selection, type: :model do
  subject(:selection) { build(:selection) }
  let(:festival) { selection.activity.festival }

  it { is_expected.to validate_presence_of(:registration_id) }
  it { is_expected.to validate_presence_of(:schedule_id) }
  it {
    is_expected
      .to validate_uniqueness_of(:schedule_id)
      .scoped_to(:registration_id)
  }

  describe '#slot' do
    subject(:slot) { selection.slot }
    it { is_expected.to eq selection.schedule.slot }
  end

  describe '#destroy' do
    it 'checks the waitlist' do
      expect(CheckWaitlist)
        .to receive(:new)
        .with(selection.schedule)
        .and_call_original
      selection.destroy
    end

    it 'promotes someone else into this spot' do
      selection.schedule.update!(maximum: 1)
      other_registration = create(:registration, festival: festival)
      create(
        :waitlist,
        registration: other_registration,
        schedule: selection.schedule
      )
      expect { selection.destroy }
        .to change(Waitlist, :count)
        .by(-1)
        .and change { other_registration.selections.allocated.count }
        .by(1)
    end
  end

  describe '.included_in_limit' do
    subject(:included_selections) { schedule.selections.included_in_limit }
    let(:schedule) { create(:schedule) }
    let(:selection) { create(:selection, schedule: schedule) }

    shared_context 'after some time' do
      around do |example|
        Timecop.travel(selection.created_at + 10.minutes) { example.run }
      end
    end

    context 'when not registered' do
      it { is_expected.to include(selection) }

      context 'and some time has elapsed' do
        include_context 'after some time'
        it { is_expected.not_to include(selection) }
      end
    end

    context 'when registered' do
      let(:selection) do
        create(:selection, schedule: schedule).tap(&:registered!)
      end

      it { is_expected.to include(selection) }

      context 'and some time has elapsed' do
        include_context 'after some time'
        it { is_expected.to include(selection) }
      end
    end
  end
end
