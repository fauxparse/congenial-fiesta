# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ScheduledActivity, type: :presenter do
  subject(:scheduled_activity) do
    ScheduledActivity.new(
      schedule,
      registration: registration,
      selection: selection
    )
  end
  let(:schedule) { create(:schedule, activity: activity) }
  let(:activity) { create(:workshop, level_list: %w[rookie]) }
  let(:registration) { nil }
  let(:selection) { nil }

  describe 'compared' do
    subject { scheduled_activity <=> other }
    let(:other) { ScheduledActivity.new(other_schedule) }
    let(:other_activity) { create(:workshop, festival: activity.festival) }

    context 'with another activity at the same time' do
      let(:other_schedule) do
        create(
          :schedule,
          activity: other_activity,
          starts_at: schedule.starts_at
        )
      end

      it { is_expected.to be_negative }
    end

    context 'with an earlier activity' do
      let(:other_schedule) do
        create(
          :schedule,
          activity: other_activity,
          starts_at: schedule.starts_at - 1.hour
        )
      end

      it { is_expected.to be_positive }
    end
  end

  describe '#available?' do
    subject { scheduled_activity.available? }

    it { is_expected.to be true }

    context 'when presenting' do
      let(:registration) { create(:registration, festival: activity.festival) }
      before do
        activity.presenters.create!(participant: registration.participant)
      end

      it { is_expected.to be false }
    end
  end

  describe '#compulsory?' do
    subject { scheduled_activity.compulsory? }

    it { is_expected.to be false }

    context 'when registered' do
      let(:registration) { create(:registration, festival: activity.festival) }

      it { is_expected.to be false }

      context 'and presenting' do
        before do
          activity.presenters.create!(participant: registration.participant)
        end

        it { is_expected.to be true }
      end
    end
  end

  describe '#day' do
    subject { scheduled_activity.day }
    it { is_expected.to eq activity.festival.start_date }
  end

  describe '#selected?' do
    subject { scheduled_activity.selected? }
    let(:registration) { create(:registration, festival: activity.festival) }

    it { is_expected.to be false }

    context 'when selected' do
      let(:selection) do
        create(:selection, schedule: schedule, registration: registration)
      end

      it { is_expected.to be true }
    end
  end

  describe '#sorted_level_list' do
    subject { scheduled_activity.sorted_level_list }

    it { is_expected.to eq %w[rookie] }

    context 'for a show' do
      let(:activity) { create(:show) }

      it { is_expected.to eq [] }
    end
  end

  describe '#to_partial_path' do
    subject { scheduled_activity.to_partial_path }
    it { is_expected.to eq 'workshop' }
  end
end
