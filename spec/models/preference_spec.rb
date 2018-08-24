# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Preference, type: :model do
  subject(:preference) { create(:preference, schedule: schedule) }
  let(:schedule) { create(:schedule) }

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
