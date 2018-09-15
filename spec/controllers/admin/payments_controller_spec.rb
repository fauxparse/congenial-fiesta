# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PaymentsController, type: :request do
  subject { response }
  let(:admin) { create(:admin) }
  let(:festival) { create(:festival) }
  let(:registration) { create(:registration, festival: festival) }
  let(:payment) do
    create(:internet_banking_payment, registration: registration)
  end
  let(:json) { JSON.parse(response.body).deep_symbolize_keys }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/payments' do
    before { get admin_payments_path(festival) }
    it { is_expected.to be_successful }
  end

  describe 'GET /admin/:year/payments/:id' do
    before { get admin_payment_path(festival, payment, format: :json) }

    it { is_expected.to be_successful }

    describe 'JSON' do
      subject { json }
      it { is_expected.to include id: payment.to_param }
    end
  end

  describe 'PUT /admin/:year/payments/:id' do
    def do_update
      put admin_payment_path(festival, payment, format: :json),
        params: { payment: { state: 'approved' } }
    end

    it 'updates the payment' do
      expect { do_update }
        .to change { payment.reload.state }
        .from('pending')
        .to('approved')
      expect(json).to include state: 'approved'
    end
  end
end
