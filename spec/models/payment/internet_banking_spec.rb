# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Payment::InternetBanking do
  subject(:payment) do
    create(:internet_banking_payment)
  end

  it { is_expected.to be_pending }

  describe '#payment_method' do
    it 'is the downcased version of the class name' do
      expect(payment.payment_method).to eq 'internet_banking'
    end
  end

  describe '.payment_method' do
    it 'is the downcased version of the class name' do
      expect(described_class.payment_method).to eq 'internet_banking'
    end
  end
end
