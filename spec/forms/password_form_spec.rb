# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordForm, type: :form do
  subject(:form) { PasswordForm.new(participant, params) }
  let(:password) { 'n3wp4$$w0rd' }

  context 'for a participant with no password' do
    let(:participant) { create(:participant) }

    context 'with valid params' do
      let(:params) { { password: password, password_confirmation: password } }

      it 'succeeds' do
        expect(form.save).to be_truthy
      end

      it 'creates a password' do
        expect { form.save }.to change(Identity::Password, :count).by(1)
      end
    end

    context 'with invalid params' do
      let(:params) { { password: password, password_confirmation: 'bad' } }

      it 'does not create a password' do
        expect { form.save }.not_to change(Identity::Password, :count)
      end

      it 'has an error' do
        expect(form.save).to be_falsy
        expect(form).to have_exactly(1).error_on(:password_confirmation)
      end
    end

    context 'with blank params' do
      let(:params) { {} }

      it 'has an error' do
        expect(form.save).to be_falsy
        expect(form).to have_exactly(1).error_on(:password)
      end
    end
  end

  context 'for a participant with an existing password' do
    let!(:participant) { create(:participant, :with_password) }

    context 'with valid params' do
      let(:params) do
        {
          current_password: attributes_for(:password_identity)[:password],
          password: password,
          password_confirmation: password
        }
      end

      it 'is successful' do
        form.save
      end

      it 'updates the existing password' do
        expect { form.save }
          .to change { participant.identities.first.reload.password_digest }
      end

      it 'does not create a new password' do
        expect { form.save }.not_to change(Identity::Password, :count)
      end
    end

    context 'with invalid current password' do
      let(:params) do
        {
          current_password: 'bad',
          password: password,
          password_confirmation: password
        }
      end

      it 'does not update the existing password' do
        expect { form.save }
          .not_to change { participant.identities.first.reload.password_digest }
      end

      it 'does not create a password' do
        expect { form.save }.not_to change(Identity::Password, :count)
      end

      it 'has an error' do
        expect(form.save).to be_falsy
        expect(form).to have_exactly(1).error_on(:current_password)
      end
    end
  end
end
