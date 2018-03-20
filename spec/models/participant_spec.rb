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
end
