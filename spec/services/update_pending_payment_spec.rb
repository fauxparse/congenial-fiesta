# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UpdateAmountPending, type: :service do
  subject(:service) { UpdateAmountPending.new(registration) }
  let(:registration) { create(:registration, :with_workshops) }
  let(:festival) { registration.festival }
  let!(:payment) do
    create(
      :internet_banking_payment,
      registration: registration,
      amount: Cart.new(registration).total
    )
  end

  context 'after earlybird' do
    around do |example|
      Timecop.freeze(festival.start_date.midnight - 1.week) do
        registration.selections.each(&:allocated!)
        registration.update(completed_at: Time.zone.now)
        example.run
      end
    end

    context 'when the number of workshops has not changed' do
      it 'does not change the payment amount' do
        expect { service.call }.not_to change { payment.reload.amount }
      end
    end

    context 'when the number of workshops has changed' do
      before do
        registration.selections.last.destroy
        registration.reload
      end

      it 'changes the payment amount' do
        pricing = PricingModel.for_festival(festival)
        expect { service.call }
          .to change { payment.reload.amount }
          .from(pricing.by_workshop_count(3))
          .to(pricing.by_workshop_count(2))
      end
    end

    context 'when a voucher has been added' do
      before do
        create(:voucher, registration: registration, workshop_count: 4)
      end

      it 'cancels the payment' do
        expect { service.call }
          .to change { payment.reload.state }
          .from('pending')
          .to('cancelled')
      end
    end
  end
end
