require 'rails_helper'

RSpec.describe PaymentsController, type: :request do
  subject { response }

  describe 'POST /payments/paypal/:id' do
    let(:payment) { create(:payment, kind: 'pay_pal') }

    let(:paypal_response) do
      {
        'mc_gross' => payment.amount.format(symbol: false),
        'invoice' => payment.to_param,
        'protection_eligibility' => 'Eligible',
        'address_status' => 'confirmed',
        'payer_id' => 'KCV5STHBT2PR4',
        'address_street' => '123 Sample St',
        'payment_date' => '18:52:57 Sep 01, 2018 PDT',
        'payment_status' => payment_status,
        'charset' => 'windows-1252',
        'address_zip' => '6004',
        'first_name' => 'Buyer',
        'mc_fee' => '5.89',
        'address_country_code' => 'NZ',
        'address_name' => 'Buyer Test',
        'notify_version' => '3.9',
        'custom' => '',
        'payer_status' => 'verified',
        'business' => 'merchant@example.com',
        'address_country' => 'New Zealand',
        'address_city' => 'Wellington',
        'quantity' => '1',
        'verify_sign' => '[hash]',
        'payer_email' => 'payer@example.com',
        'txn_id' => '0KC25164NJ0684220',
        'payment_type' => 'instant',
        'last_name' => 'Test',
        'address_state' => '',
        'receiver_email' => 'payer@example.com',
        'payment_fee' => '',
        'receiver_id' => 'GL3PF9A9Y2TRE',
        'txn_type' => 'web_accept',
        'item_name' => 'NZIF 2018',
        'mc_currency' => 'NZD',
        'item_number' => '',
        'residence_country' => 'NZ',
        'test_ipn' => '1',
        'transaction_subject' => '',
        'payment_gross' => '',
        'ipn_track_id' => '9926f5bc2644d',
        'id' => payment.to_param
      }
    end

    def post_notification
      post paypal_callback_url(payment), params: paypal_response
    end

    context 'for a successful payment' do
      let(:payment_status) { 'Completed' }

      it 'completes the payment' do
        expect { post_notification }
          .to change { payment.reload.state }
          .from('pending')
          .to('approved')
      end

      it 'is successful' do
        post_notification
        expect(response).to be_successful
      end
    end

    context 'for an unsuccessful payment' do
      let(:payment_status) { 'Denied' }

      it 'fails the payment' do
        expect { post_notification }
          .to change { payment.reload.state }
          .from('pending')
          .to('declined')
      end

      it 'is successful' do
        post_notification
        expect(response).to be_successful
      end
    end
  end
end
