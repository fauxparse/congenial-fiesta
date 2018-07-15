# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Presenter, type: :model do
  subject(:presenter) { build(:presenter) }

  it { is_expected.to validate_presence_of(:activity_id) }
  it { is_expected.to validate_presence_of(:participant_id) }
  it {
    is_expected
      .to validate_uniqueness_of(:participant_id)
      .scoped_to(:activity_id)
  }
end