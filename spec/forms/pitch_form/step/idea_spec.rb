# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchForm::Step::Idea do
  subject(:step) { PitchForm::Step::Idea.new(pitch) }

  let(:pitch) { create(:pitch) }

  describe '#apply!' do
    it 'submits the pitch' do
      step.attributes = { activity: { name: 'Test' } }
      step.apply!
      expect(pitch.reload.info.activity.name).to eq 'Test'
    end
  end

  describe '#method_missing' do
    it 'still raises for bad method names' do
      expect { step.foo }.to raise_error NoMethodError
    end
  end
end
