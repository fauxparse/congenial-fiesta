# frozen_string_literal: true

class PaymentMethod
  class PayPal < PaymentMethod
    def submit!
      payment.save
      publish(:redirect, paypal_url)
    end

    def process!(params)
      case params[:payment_status]
      when 'Completed', 'Processed'
        complete_payment(params)
      when 'Pending'
        pending_payment(params)
      when 'Denied', 'Failed'
        fail_payment(params)
      when 'Expired', 'Reversed', 'Voided'
        cancel_payment(params)
      when 'Refunded'
        refund_payment(params)
      end
    end

    private

    PAYPAL_HOST =
      Rails.application.credentials.paypal.dig(Rails.env.to_sym, :host)

    PAYPAL_MERCHANT =
      Rails.application.credentials.paypal.dig(Rails.env.to_sym, :merchant)

    def paypal_url
      registration = payment.registration
      festival = registration.festival

      values = {
        business: PAYPAL_MERCHANT,
        cmd: '_xclick',
        upload: 1,
        return: paypal_return_url(payment),
        notify_url: paypal_callback_url(payment),
        invoice: payment.to_param,
        amount: payment.amount,
        currency_code: payment.amount.currency.iso_code,
        item_name: festival.to_s
      }
      "#{PAYPAL_HOST}/cgi-bin/webscr?" + values.to_query
    end

    def complete_payment(params)
      update_payment(:approved, params)
      complete_registration if paid_in_full?
    end

    def pending_payment(params)
      update_payment(:pending, params)
    end

    def fail_payment(params)
      update_payment(:declined, params)
    end

    def cancel_payment(params)
      update_payment(:cancelled, params)
    end

    def refund_payment(params)
      update_payment(:refunded, params)
    end

    def update_payment(state, params)
      payment.update!(
        state: state,
        reference: params[:txn_id],
        details: sanitize_transaction_data(params.to_h)
      )
    end

    def sanitize_transaction_data(data)
      if data[:charset]
        data.to_a.each.with_object({}) do |(key, value), hash|
          hash[key] = value.force_encoding('windows-1252').encode('utf-8')
        end
      else
        data
      end
    end

    def paid_in_full?
      Cart.new(registration).paid?
    end

    def complete_registration
      CompleteRegistration.new(registration).call unless registration.completed?
    end

    delegate :registration, to: :payment
  end
end
