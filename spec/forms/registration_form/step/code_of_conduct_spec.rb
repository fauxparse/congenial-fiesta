# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm::Step::CodeOfConduct do
  subject(:step) { RegistrationForm::Step::CodeOfConduct.new(form) }
  let(:form) do
    double(
      RegistrationForm,
      registration: registration,
      participant: participant
    )
  end
  let(:participant) { create(:participant, :with_password) }
  let!(:registration) { create(:registration, participant: participant) }

  describe '#to_param' do
    subject { step.to_param }
    it { is_expected.to eq 'code_of_conduct' }
  end

  describe '#update' do
    let(:attributes) { { code_of_conduct_accepted: true } }

    it 'updates the participant’s details' do
      Timecop.freeze do
        expect { step.update(attributes) }
          .to change { registration.reload.code_of_conduct_accepted_at }
          .to Time.zone.now
      end
    end

    it 'does not create a new registration' do
      expect { step.update(attributes) }
        .not_to change(Registration, :count)
    end
  end
end
