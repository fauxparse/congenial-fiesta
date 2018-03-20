# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoginForm, type: :form do
  subject(:form) { LoginForm.new(**credentials) }
  let!(:existing) { create(:participant, :with_password) }
  let(:credentials) { {} }

  describe '#participant' do
    subject(:participant) { form.participant }

    context 'with valid credentials' do
      let(:credentials) { { email: existing.email, password: 'p4$$w0rd' } }
      it { is_expected.to eq participant }
    end

    context 'with a bad password' do
      let(:credentials) { { email: existing.email, password: 'bad' } }
      it { is_expected.to be_nil }
    end
  end

  describe '#valid?' do
    context 'with valid credentials' do
      let(:credentials) { { email: existing.email, password: 'p4$$w0rd' } }
      it { is_expected.to be_valid }
    end

    context 'with a bad password' do
      let(:credentials) { { email: existing.email, password: 'bad' } }
      it { is_expected.not_to be_valid }
      it 'populates errors' do
        form.validate
        expect(form).to have_exactly(1).error_on(:email)
        expect(form.errors[:email]).to include 'or password incorrect'
      end
    end

    context 'with no email address' do
      let(:credentials) { { password: 'p4$$w0rd' } }
      it { is_expected.not_to be_valid }
    end
  end
end
