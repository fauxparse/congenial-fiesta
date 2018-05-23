# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchForm::Step::Finish do
  subject(:step) { PitchForm::Step::Finish.new(pitch) }

  let(:pitch) { create(:pitch) }

  describe '#apply!' do
    it 'submits the pitch' do
      expect { step.apply! }
        .to change { pitch.submitted? }
        .from(false)
        .to(true)
    end
  end
end
