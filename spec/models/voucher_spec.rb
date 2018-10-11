# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Voucher, type: :model do
  subject(:voucher) { build(:voucher) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:note) }
  it { is_expected.to validate_numericality_of(:workshop_count)
    .is_greater_than(0) }
end
