# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart do
  subject(:cart) { Cart.new(registration) }
  let(:registration) { create(:registration, :with_workshops) }

  before do
    allow_any_instance_of(RegistrationStage)
      .to receive(:earlybird?)
      .and_return(true)
  end

  describe '#count' do
    subject(:count) { cart.count }
    it { is_expected.to eq 3 }
  end

  describe '#paid' do
    subject(:paid) { cart.paid }

    it { is_expected.to be_zero }

    context 'with pending payments' do
      let!(:payment) { create(:payment, registration: registration) }

      it { is_expected.to be_zero }
    end

    context 'with approved payments' do
      let!(:payment) do
        create(:payment, registration: registration).tap(&:approved!)
      end

      it { is_expected.to eq payment.amount }
    end
  end

  describe '#payment_confirmed?' do
    subject { cart.payment_confirmed? }

    it { is_expected.to be_falsy }

    context 'when payment has been made' do
      let!(:payment) do
        create(:payment, registration: registration, amount: cart.total)
      end

      it { is_expected.to be_falsy }

      context 'and approved' do
        before { payment.approved! }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#total' do
    subject(:total) { cart.total }

    it { is_expected.to eq(Money.new(16000)) }

    context 'with vouchers applied' do
      before do
        2.times do
          registration.vouchers.create!(workshop_count: 1, note: 'free')
        end
      end

      it { is_expected.to eq(Money.new(5000)) }
    end
  end

  describe '#workshop_value' do
    subject { cart.workshop_value }
    it { is_expected.to be > cart.total }
  end

  describe '#to_partial_path' do
    subject { cart.to_partial_path }
    it { is_expected.to eq 'registrations/cart' }
  end
end
