# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Festival, type: :model do
  subject(:festival) { build(:festival) }

  it { is_expected.to validate_presence_of(:year) }
  it { is_expected.to validate_uniqueness_of(:year) }
  it { is_expected.to validate_presence_of(:start_date) }
  it { is_expected.to validate_presence_of(:end_date) }

  context 'with dates out of order' do
    before do
      festival.end_date = festival.start_date - 1
      festival.validate
    end

    it { is_expected.not_to be_valid }
    it { is_expected.to have_exactly(1).error_on(:end_date) }

    it 'generates the correct error_message' do
      expect(festival.errors[:end_date])
        .to include 'must be on or after 20 October, 2018'
    end
  end

  context 'with earlybird cutoff before registrations open' do
    before do
      festival.registrations_open_at = Time.zone.now
      festival.earlybird_cutoff = 1.day.ago
    end

    it 'is invalid' do
      expect(festival).not_to be_valid
      expect(festival).to have_exactly(1).error_on(:earlybird_cutoff)
    end
  end
end
