# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordReset, type: :model do
  subject(:password_reset) { PasswordReset.create(participant: participant) }

  let(:participant) { create(:participant) }

  it { is_expected.to be_valid }
  it { is_expected.not_to be_expired }
end
