# frozen_string_Literal: true

class RegistrationForm
  class Step
    class PaymentDetails < Step
      def to_param
        'payment'
      end

      def sublabel
        cart.total.format
      end

      def cart
        @cart ||= Cart.new(registration)
      end
    end
  end
end
