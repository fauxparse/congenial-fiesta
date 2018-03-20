# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity::Oauth, type: :model do
  subject(:identity) { build(:oauth_identity, participant: participant) }
  let(:participant) { create(:participant) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_absence_of(:password_digest) }

  it 'does not support more than one account per participant/provider' do
    expect(identity)
      .to validate_uniqueness_of(:provider)
      .case_insensitive
      .scoped_to(:participant_id)
  end
end
