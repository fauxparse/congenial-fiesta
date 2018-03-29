# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchForm::Step::ParticipantInfo do
  subject(:step) { PitchForm::Step::ParticipantInfo.new(pitch) }

  let(:pitch) do
    create(:pitch, info: Pitch::Info.new(info))
  end

  let(:info) do
    {
      participant: {
        name: 'Matt',
        city: 'Wellington',
        country_code: 'NZ',
        bio: 'clear eyes, full heart, can’t sleep'
      },
      code_of_conduct_accepted: true
    }
  end

  it { is_expected.to be_valid }

  describe '#attributes=' do
    it 'assigns attributes' do
      expect { step.attributes = { name: 'Jen' } }
        .to change { pitch.info.participant.name }
        .from('Matt')
        .to('Jen')
    end
  end

  describe '#name' do
    it 'defaults to the participant’s name' do
      step.name = nil
      expect(step.name).to eq pitch.participant.name
    end
  end

  describe '#code_of_conduct' do
    it 'must be accepted' do
      step.code_of_conduct = '0'
      expect(step).not_to be_valid
    end
  end

  describe '#title' do
    subject(:title) { step.title }
    it { is_expected.to eq 'About you' }
  end

  context 'for a new participant' do
    let(:pitch) { Pitch.new }
    before do
      step.attributes = {
        participant: {
          name: 'Matt',
          email: 'fauxparse@gmail.com',
          password: 'p4$$w0rd',
          password_confirmation: 'p4$$w0rd',
          city: 'Wellington',
          country_code: 'NZ',
          bio: 'clear eyes, full heart, can’t sleep'
        },
        code_of_conduct: true
      }
    end

    describe '#apply!' do
      it 'creates a new participant' do
        expect { step.apply! }
          .to change(Participant, :count)
          .by(1)
      end
    end
  end
end
