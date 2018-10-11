# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::VouchersController, type: :request do
  subject { response }
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }
  let(:registration) { create(:registration, festival: festival) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/vouchers' do
    before { get admin_vouchers_path(festival) }
    it { is_expected.to be_successful }
  end

  describe 'GET /admin/:year/vouchers/:id' do
    let(:voucher) { create(:voucher, registration: registration) }
    before { get new_admin_voucher_path(festival, voucher) }
    it { is_expected.to be_successful }
  end

  describe 'GET /admin/:year/vouchers/new' do
    before { get new_admin_voucher_path(festival) }
    it { is_expected.to be_successful }
  end

  describe 'POST /admin/:year/vouchers' do
    let(:params) do
      {
        voucher: {
          registration_id: registration.id,
          workshop_count: 2,
          note: 'a very good boy'
        }
      }
    end

    it 'creates a voucher' do
      expect { post admin_vouchers_path(festival), params: params }
        .to change(Voucher, :count)
        .by(1)
      expect(response).to redirect_to admin_vouchers_path(festival)
    end

    context 'with bad params' do
      let(:params) do
        {
          voucher: {
            registration_id: registration.id,
            workshop_count: 2
          }
        }
      end

      it 'does not create a voucher' do
        expect { post admin_vouchers_path(festival), params: params }
          .not_to change(Voucher, :count)
        expect(response).not_to be_redirect
      end
    end
  end

  describe 'PATCH /admin/:year/vouchers/:id' do
    let(:voucher) { create(:voucher, registration: registration) }
    let(:params) do
      { voucher: { workshop_count: 3, } }
    end

    it 'updates the voucher' do
      expect { put admin_voucher_path(festival, voucher), params: params }
        .to change { voucher.reload.workshop_count }
        .from(1)
        .to(3)
      expect(response).to redirect_to admin_vouchers_path(festival)
    end

    context 'with bad params' do
      let(:params) do
        { voucher: { workshop_count: 0 } }
      end

      it 'does not update the voucher' do
        expect { put admin_voucher_path(festival, voucher), params: params }
          .not_to change { voucher.reload.workshop_count }
        expect(response).not_to be_redirect
      end
    end
  end

  describe 'DELETE /admin/:year/vouchers/:id' do
    let!(:voucher) { create(:voucher, registration: registration) }

    it 'updates the voucher' do
      expect { delete admin_voucher_path(festival, voucher) }
        .to change(Voucher, :count)
        .by(-1)
      expect(response).to redirect_to admin_vouchers_path(festival)
    end
  end
end
