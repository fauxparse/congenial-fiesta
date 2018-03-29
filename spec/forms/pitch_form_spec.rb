# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchForm do
  subject(:form) { PitchForm.new(pitch) }

  describe '#participant' do
    subject(:participant) { form.participant }

    context 'for a new pitch' do
      let(:pitch) { Pitch.new }
      it { is_expected.to be_a Participant }
    end

    context 'for an existing pitch' do
      let(:pitch) { create(:pitch) }
      it { is_expected.to be_a Participant }
    end
  end
end
