# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Selection, type: :model do
  subject(:selection) { build(:selection) }

  it { is_expected.to validate_presence_of(:registration_id) }
  it { is_expected.to validate_presence_of(:schedule_id) }
  it {
    is_expected
      .to validate_uniqueness_of(:schedule_id)
      .scoped_to(:registration_id)
  }

  describe '.included_in_limit' do
    subject(:included_selections) { schedule.selections.included_in_limit }
    let(:schedule) { create(:schedule) }
    let(:selection) { create(:selection, schedule: schedule) }

    shared_context 'after some time' do
      around do |example|
        Timecop.travel(selection.created_at + 10.minutes) { example.run }
      end
    end

    context 'when not confirmed' do
      it { is_expected.to include(selection) }

      context 'and some time has elapsed' do
        include_context 'after some time'
        it { is_expected.not_to include(selection) }
      end
    end

    context 'when confirmed' do
      let(:selection) do
        create(:selection, schedule: schedule).tap(&:confirmed!)
      end

      it { is_expected.to include(selection) }

      context 'and some time has elapsed' do
        include_context 'after some time'
        it { is_expected.to include(selection) }
      end
    end
  end
end
