# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Presenter, type: :model do
  subject(:presenter) { build(:presenter) }
  let(:participant) { presenter.participant }

  it { is_expected.to validate_presence_of(:activity) }
  it { is_expected.to validate_presence_of(:participant_id) }
  it {
    is_expected
      .to validate_uniqueness_of(:participant_id)
      .scoped_to(:activity_id)
  }

  describe '#to_s' do
    subject { presenter.to_s }
    it { is_expected.to eq presenter.participant.name }
  end

  describe '#location' do
    subject(:location) { presenter.location }

    context 'for someone from New Zealand' do
      before do
        participant.city = nil
        participant.country_code = 'nz'
      end

      it { is_expected.to eq 'NZ' }

      context 'with a city set' do
        before { participant.city = 'Christchurch' }
        it { is_expected.to eq 'Christchurch' }
      end
    end

    context 'for someone from Melbourne' do
      before do
        participant.city = 'Melbourne'
        participant.country_code = 'au'
      end

      it { is_expected.to eq 'Aus' }
    end
  end
end
