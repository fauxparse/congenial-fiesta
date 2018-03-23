# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity::Oauth, type: :model do
  subject(:identity) { build(:oauth_identity, participant: participant) }
  let(:participant) { create(:participant) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_absence_of(:password_digest) }

  context 'with more than one account per participant/provider' do
    let(:participant) { create(:participant, :with_oauth) }
    it { is_expected.not_to be_valid }
  end
end
