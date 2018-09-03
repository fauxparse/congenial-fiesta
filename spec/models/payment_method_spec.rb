# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentMethod, type: :model do
  subject(:payment_method) { payment.payment_method }
  let(:payment) { build(:internet_banking_payment) }

  describe '#===' do
    it 'matches' do
      expect(payment_method === 'internet_banking').to be true
    end
  end

  describe '#to_param' do
    subject { payment_method.to_param }

    it { is_expected.to eq 'internet_banking' }
  end

  describe '.to_param' do
    subject { payment_method.class.to_param }

    it { is_expected.to eq 'internet_banking' }
  end

  describe '.to_partial_path' do
    subject { payment_method.class.to_partial_path }

    it { is_expected.to eq 'registrations/payment_method' }
  end
end
