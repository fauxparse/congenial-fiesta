# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Registration, type: :model do
  subject(:registration) { build(:registration) }

  it { is_expected.to be_valid }
  it { is_expected.to be_pending }
end
