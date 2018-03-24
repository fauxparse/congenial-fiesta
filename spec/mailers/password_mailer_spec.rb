# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  describe '.password_reset_email' do
    subject(:email) { PasswordMailer.password_reset_email(password_reset) }
    let(:password_reset) { PasswordReset.create(participant: participant) }
    let(:participant) { create(:participant) }

    it { is_expected.to be_delivered_to participant.email }
    it { is_expected.to have_body_text reset_password_path(password_reset) }
  end
end
