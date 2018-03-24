# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ResetPassword, type: :service do
  subject(:service) { ResetPassword.new(email) }

  context 'for a valid participant' do
    let(:email) { create(:participant).email }

    it 'creates a password reset token' do
      expect { service.call }.to change(PasswordReset, :count).by(1)
    end
  end

  context 'for an invalid email address' do
    let(:email) { 'bad@example.com' }

    it 'creates a password reset token' do
      expect { service.call }.not_to change(PasswordReset, :count)
    end
  end
end
