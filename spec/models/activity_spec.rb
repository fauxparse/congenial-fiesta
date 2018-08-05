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

  describe '#presenter_participant_ids=' do
    let(:participant) { create(:participant) }

    before do
      activity.save!
      activity.presenters.create!(participant: participant)
    end

    def do_update
      activity.update!(presenter_participant_ids: ids)
    end

    context 'with a new participant' do
      let(:ids) { [participant.to_param, create(:participant).to_param] }

      it 'creates a presenter' do
        expect { do_update }.to change(Presenter, :count).by(1)
      end
    end

    context 'with an empty set' do
      let(:ids) { [] }

      it 'deletes a presenter' do
        expect { do_update }.to change(Presenter, :count).by(-1)
      end
    end

    context 'with the same ids' do
      let(:ids) { [participant.to_param] }

      it 'doesn’t do anything' do
        expect { do_update }.not_to change { activity.reload.presenter_ids }
      end
    end
  end
end
