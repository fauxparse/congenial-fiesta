# frozen_string_literal: true

class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :email) unless valid_email_address?(value)
  end

  private

  def valid_email_address?(email)
    email.present? && email =~ /\A[^@\s]+@[^@\s]+\z/
  end
end
