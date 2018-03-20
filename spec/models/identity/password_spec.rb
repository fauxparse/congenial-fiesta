# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Identity::Password, type: :model do
  subject(:identity) { build(:password_identity, participant: participant) }
  let(:participant) { create(:participant) }

  it { is_expected.to be_valid }

  context 'when the participant already has a password' do
    before { create(:password_identity, participant: participant) }

    it { is_expected.not_to be_valid }
  end
end
