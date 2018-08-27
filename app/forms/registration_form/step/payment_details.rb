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

      def payment_method=(type)
        unless payment_method == type
          if payment&.persisted?
            payment.state = 'cancelled'
          else
            payment&.mark_for_destruction
          end

          @payment = build_payment(type)
        end
      end

      def payment_methods
        Payment.subclasses.map { |klass| PaymentMethod.new(klass) }
      end

      private

      def payments_in_place
        errors.add(:payment_method, :blank) unless cart.paid?
      end

      def payment
        @payment ||= registration.payments.to_a.select(&:pending?).last
      end

      def build_payment(type)
        registration.payments.build(
          type: "Payment::#{type.camelize}",
          amount: cart.to_pay
        )
      end

      class PaymentMethod
        def initialize(klass)
          @klass = klass
        end

        def to_partial_path
          'registrations/payment_method'
        end

        delegate :payment_method, to: :klass

        private

        attr_reader :klass
      end
    end
  end
end
