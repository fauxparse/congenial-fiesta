# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConvertPitch::ReturnPerformance, type: :service do
  subject(:converter) { ConvertPitch::ReturnPerformance.new(pitch) }
  let(:pitch) { create(:pitch, :for_directed_performance, festival: festival) }
  let(:festival) { create(:festival) }

  describe '#call' do
    it 'does not create a workshop' do
      expect { converter.call }.not_to change(Workshop, :count)
    end

    it 'creates a show' do
      expect { converter.call }.to change(Show, :count).by(1)
    end

    it 'creates a presenter' do
      expect { converter.call }.to change(Presenter, :count).by(1)
    end
  end

  describe '#presenter' do
    subject(:presenter) { converter.show.presenters.first }
    before { converter.call }

    it 'is associated to the participant' do
      expect(presenter.participant).to eq pitch.participant
    end

    it 'has the correct activity' do
      expect(presenter.activity.name).to eq pitch.info.activity.name
    end
  end
end
