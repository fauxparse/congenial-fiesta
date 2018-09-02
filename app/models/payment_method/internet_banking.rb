# frozen_string_literal: true

class PaymentMethod
  class InternetBanking < PaymentMethod
    def submit!
      payment.update!(reference: generate_reference)
      publish(:success)
    end

    def self.configuration
      @configuration ||= Rails.application.credentials.internet_banking
    end

    def self.account_name
      configuration[:name]
    end

    def self.account_number
      configuration[:account]
    end

    private

    HASHIDS_SALT = '6439147f16081e2e7edb4ebad654152f'
    HASHIDS_ALPHABET = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ'

    def generate_reference
      hashids = Hashids.new(HASHIDS_SALT, 8, HASHIDS_ALPHABET)
      hashids.encode(payment.id)
    end
  end
end
