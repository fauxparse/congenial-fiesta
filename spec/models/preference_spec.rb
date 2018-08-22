# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Preference, type: :model do
  subject(:preference) do
    create(:preference, schedule: schedule, registration: registration)
  end
  let(:schedule) { create(:schedule) }
  let(:registration) do
    create(:registration, festival: schedule.activity.festival)
  end

  it {
    is_expected
      .to validate_uniqueness_of(:schedule_id)
      .scoped_to(:registration_id)
  }

  describe '#slot' do
    subject(:slot) { preference.slot }
    it { is_expected.to eq schedule.slot }
  end
end
