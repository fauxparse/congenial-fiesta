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
end
