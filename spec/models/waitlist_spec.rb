# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Waitlist, type: :model do
  subject(:waitlist) do
    create(:waitlist, schedule: schedule, registration: registration)
  end
  let(:schedule) { create(:schedule, activity: workshop) }
  let(:workshop) { create(:workshop) }
  let(:registration) { create(:registration, festival: workshop.festival) }

  it { is_expected
    .to validate_uniqueness_of(:registration_id)
    .scoped_to(:schedule_id) }
end
