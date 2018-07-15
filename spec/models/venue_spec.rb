# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Venue, type: :model do
  subject(:venue) { build(:venue) }

  it { is_expected.to validate_presence_of(:latitude) }
  it { is_expected.to validate_numericality_of(:latitude) }
  it { is_expected.to validate_presence_of(:longitude) }
  it { is_expected.to validate_numericality_of(:longitude) }
end
