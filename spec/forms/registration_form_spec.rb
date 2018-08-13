# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm do
  subject(:form) { RegistrationForm.new(festival, participant, step: step) }
  let(:festival) { create(:festival) }
  let(:participant) { create(:participant) }
  let(:step) { nil }

  context 'for a new participant' do
    describe '#current_step' do
      subject(:current_step) { form.current_step }
      it { is_expected.to eq form.steps.first }

      context 'when a later step is requested' do
        let(:step) { 'later' }
        it { is_expected.to eq form.steps.first }
      end
    end
  end
end
