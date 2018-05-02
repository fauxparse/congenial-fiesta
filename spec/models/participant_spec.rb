# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject(:participant) { build(:participant) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.not_to be_admin }

  context 'with a bad email address' do
    subject(:participant) { build(:participant, email: 'bad') }

    it 'is invalid' do
      expect(participant).not_to be_valid
      expect(participant).to have_exactly(1).error_on(:email)
    end
  end

  context 'with no email address' do
    subject(:participant) { build(:participant, email: nil) }

    it 'is valid' do
      expect(participant).to be_valid
    end

    context 'when there is an existing participant with no email address' do
      before { create(:participant, email: nil) }

      it 'is valid' do
        expect(participant).to be_valid
      end
    end
  end

  context 'as an administrator' do
    subject(:participant) { create(:admin) }

    it { is_expected.to be_valid }
    it { is_expected.to be_admin }

    context 'when all login methods are removed' do
      before { participant.identities.destroy_all }

      it { is_expected.not_to be_admin }
    end
  end

  describe '.password_authenticated' do
    subject(:participants) { Participant.password_authenticated.all }
    let!(:participant_with_password) { create(:participant, :with_password) }
    let!(:participant_without_password) { create(:participant) }

    it { is_expected.to include(participant_with_password) }
    it { is_expected.not_to include(participant_without_password) }
  end

  describe '.with_email' do
    it 'is case-insensitive' do
      participant = create(:participant)
      expect(Participant.with_email(participant.email.upcase))
        .to include(participant)
    end
  end
end
