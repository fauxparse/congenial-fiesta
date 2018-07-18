# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConvertPitch::StandaloneWorkshop, type: :service do
  subject(:converter) { ConvertPitch::StandaloneWorkshop.new(pitch) }
  let(:pitch) { create(:pitch, :for_workshop, festival: festival) }
  let(:festival) { create(:festival) }

  describe '#call' do
    it 'creates a workshop' do
      expect { converter.call }.to change(Workshop, :count).by(1)
    end

    it 'creates a presenter' do
      expect { converter.call }.to change(Presenter, :count).by(1)
    end
  end

  describe '#workshop' do
    subject(:workshop) { converter.workshop }
    before { converter.call }

    it 'belongs to the festival' do
      expect(workshop.festival).to eq festival
    end
  end

  describe '#presenter' do
    subject(:presenter) { converter.workshop.presenters.first }
    before { converter.call }

    it 'is associated to the participant' do
      expect(presenter.participant).to eq pitch.participant
    end

    it 'has the correct activity' do
      expect(presenter.activity.name).to eq pitch.info.activity.name
    end
  end
end
