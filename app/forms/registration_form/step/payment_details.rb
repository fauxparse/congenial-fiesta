# frozen_string_Literal: true

class RegistrationForm
  class Step
    class PaymentDetails < Step
      permit :payment_method

      validate :payments_in_place

      def to_param
        'payment'
      end

      def sublabel
        cart.total.format
      end

      def cart
        @cart ||= Cart.new(registration)
      end

      def payment_method
        payment&.payment_method
      end

      def payment_method=(kind)
        return if payment_method === kind

        if payment&.persisted?
          payment.state = 'cancelled'
        else
          payment&.mark_for_destruction
        end

        @payment = build_payment(kind)
      end

      def payment_methods
        PaymentMethod.all
      end

      def update(attributes = {})
        assign_attributes(attributes)
        if payment.valid?
          save
          submit_payment
        else
          publish(:error)
        end
      end

      private

      def payments_in_place
        errors.add(:payment_method, :blank) unless cart.paid?
      end

      def payment
        @payment ||= registration.payments.to_a.select(&:pending?).last
      end

      def build_payment(kind)
        registration.payments.build(kind: kind, amount: cart.to_pay)
      end

      def submit_payment
        payment.save
        payment_method
          .on(:success) { publish(:success) }
          .on(:error) { publish(:error) }
          .on(:redirect) { |url| publish(:redirect, url) }
          .submit!
      end
    end
  end
end
