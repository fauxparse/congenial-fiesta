# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm::Step::ParticipantDetails do
  subject(:step) { RegistrationForm::Step::ParticipantDetails.new(form) }
  let(:form) do
    double(
      RegistrationForm,
      registration: registration,
      participant: participant
    )
  end
  let(:participant) { Participant.new }
  let(:registration) { build(:registration, participant: participant) }

  describe '#to_param' do
    subject { step.to_param }
    it { is_expected.to eq 'details' }
  end

  context 'with a new participant' do
    let!(:participant) { Participant.new }
    it { is_expected.not_to be_valid }

    describe '#update' do
      let(:attributes) do
        {
          name: 'Kiki Hohnen',
          email: 'kiki@example.com',
          password: 'p4$$w0rd',
          password_confirmation: 'p4$$w0rd',
          city: 'Amsterdam',
          country_code: 'nl'
        }
      end

      it 'completes the step' do
        expect { step.update(attributes) }
          .to change { step.complete? }
          .from(false)
          .to(true)
      end

      it 'creates a participant' do
        expect { step.update(attributes) }
          .to change(Participant, :count)
          .by(1)
      end

      it 'creates a password' do
        expect { step.update(attributes) }
          .to change(Identity::Password, :count)
          .by(1)
      end
    end
  end

  context 'with an existing participant' do
    let!(:participant) do
      create(
        :participant,
        :with_password,
        country_code: 'nz',
        city: 'Wellington'
      )
    end

    it { is_expected.to be_valid }

    describe '#update' do
      let(:attributes) { { name: 'Kiki Hohnen' } }

      it 'updates the participant’s details' do
        expect { step.update(attributes) }
          .to change { participant.reload.name }
          .to 'Kiki Hohnen'
      end

      it 'does not create a new participant' do
        expect { step.update(attributes) }
          .not_to change(Participant, :count)
      end
    end
  end
end
