# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject(:participant) { build(:participant) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  context 'with a bad email address' do
    subject(:participant) { build(:participant, email: 'bad') }

    it 'is invalid' do
      expect(participant).not_to be_valid
      expect(participant).to have_exactly(1).error_on(:email)
    end
  end

  context 'with no email address' do
    subject(:participant) { build(:participant, email: nil) }

    it 'is invalid' do
      expect(participant).not_to be_valid
      expect(participant).to have_exactly(1).error_on(:email)
    end
  end

  describe '.password_authenticated' do
    subject(:participants) { Participant.password_authenticated.all }
    let!(:participant_with_password) { create(:participant, :with_password) }
    let!(:participant_without_password) { create(:participant) }

    it { is_expected.to include(participant_with_password) }
    it { is_expected.not_to include(participant_without_password) }
  end
end
