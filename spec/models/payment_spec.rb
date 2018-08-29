# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject(:payment) { build(:payment) }

  it { is_expected.to be_valid }
  it { is_expected.to be_pending }
  it { is_expected.to validate_presence_of(:registration_id) }
  it {
    is_expected
      .to validate_numericality_of(:amount)
      .is_greater_than_or_equal_to(0)
  }

  describe '.default_payment_type' do
    subject { Payment.default_payment_type }
    it { is_expected.to eq Payment::InternetBanking }
  end
end
