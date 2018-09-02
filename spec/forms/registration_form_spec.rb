# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm do
  subject(:form) { RegistrationForm.new(festival, participant, step: step) }
  let(:festival) { create(:festival) }
  let(:participant) { create(:participant) }
  let(:step) { nil }
  let(:participant_params) do
    {
      name: 'Kiki Hohnen',
      email: 'kiki@impro.nl',
      password: 'p4$$w0rd',
      password_confirmation: 'p4$$w0rd',
      city: 'Amsterdam',
      country_code: 'NL'
    }
  end

  context 'for a new participant' do
    let(:participant) { nil }

    describe '#current_step' do
      subject(:current_step) { form.current_step }
      it { is_expected.to eq form.steps.first }

      context 'when a later step is requested' do
        let(:step) { 'later' }
        it { is_expected.to eq form.steps.first }
      end
    end

    describe '#update' do
      it 'creates a participant' do
        expect { form.update(participant_params) }
          .to change(Participant, :count)
          .by(1)
          .and change(Registration, :count)
          .by(1)
      end

      it 'advances the step' do
        expect { form.update(participant_params) }
          .to change { form.current_step.to_param }
          .from('details')
          .to('code_of_conduct')
        expect(form.previous_step).to eql :details
      end
    end
  end

  context 'from start to finish' do
    it 'completes successfully' do
      form.on(:completed) { @complete = true }

      form.update(participant_params)
      form.update(code_of_conduct_accepted: true)
      form.update(workshops: {})
      form.update(shows: {})
      form.update(payment_method: 'internet_banking')

      expect(@complete).to be true
    end
  end

  describe '#cart' do
    subject(:cart) { form.cart }
    it { is_expected.to be_an_instance_of(Cart) }
  end
end
