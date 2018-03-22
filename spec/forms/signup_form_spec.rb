# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SignupForm do
  subject(:form) { SignupForm.new(attributes) }
  let(:valid_attributes) do
    {
      name: 'Test Participant',
      email: 'test@example.com',
      password: 'p4$$w0rd',
      password_confirmation: 'p4$$w0rd'
    }
  end

  context 'with valid attributes' do
    let(:attributes) { valid_attributes }

    it { is_expected.to be_valid }

    describe '#save' do
      it 'creates a participant' do
        expect { form.save }.to change(Participant, :count).by(1)
      end

      it 'creates a participant' do
        expect { form.save }.to change(Identity::Password, :count).by(1)
      end
    end
  end

  context 'with a bad email address' do
    let(:attributes) { valid_attributes.merge(email: 'bad') }

    it 'is invalid' do
      expect(form).not_to be_valid
      expect(form).to have_exactly(1).error_on(:email)
    end
  end

  context 'with a bad password confirmation' do
    let(:attributes) { valid_attributes.merge(password_confirmation: 'bad') }

    it 'is invalid' do
      expect(form).not_to be_valid
      expect(form).to have_exactly(1).error_on(:password_confirmation)
    end
  end
end
