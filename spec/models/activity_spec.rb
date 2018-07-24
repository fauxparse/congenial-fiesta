# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Activity, type: :model do
  subject(:activity) { build(:show) }

  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :maximum }
  it {
    is_expected
      .to validate_numericality_of(:maximum)
      .only_integer
      .is_greater_than(0)
  }

  describe '#slug' do
    subject(:slug) { activity.slug }
    let(:activity) { create(:show, name: name, festival: festival) }
    let(:festival) { create(:festival) }
    let(:name) { 'The Greatest Show on Earth' }

    it { is_expected.to eq 'the-greatest-show-on-earth' }

    context 'when an activity with that name already exists' do
      before { create(:show, name: name, festival: festival) }

      it { is_expected.to end_with(/\d+/) }
    end

    context 'when there is an activity of the same name but a different type' do
      before { create(:workshop, name: name, festival: festival) }

      it { is_expected.not_to end_with(/\d+/) }
    end
  end
end
