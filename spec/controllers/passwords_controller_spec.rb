# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordsController, type: :request do
  let(:password) { 'n3wp4$$w0rd' }

  describe 'put /password' do
    let(:password_change_request) do
      put password_path, params: { password: params }
    end

    context 'for a logged-in participant' do
      before { log_in_as(participant) }

      context 'with no password' do
        let!(:participant) { create(:participant, :with_oauth) }

        let(:params) do
          { password: password, password_confirmation: password }
        end

        it 'creates a password identity' do
          expect { password_change_request }
            .to change(Identity::Password, :count)
            .by(1)
        end

        it 'enables password login' do
          expect { password_change_request }
            .to change { participant.reload.password? }
            .from(false)
            .to(true)
        end

        it 'redirects to the participant’s profile' do
          password_change_request
          expect(response).to redirect_to profile_path
        end
      end

      context 'with a password' do
        let!(:participant) { create(:participant, :with_password) }

        let(:params) do
          {
            current_password: attributes_for(:password_identity)[:password],
            password: password,
            password_confirmation: password
          }
        end

        it 'does not create a password identity' do
          expect { password_change_request }
            .not_to change(Identity::Password, :count)
        end

        it 'redirects to the participant’s profile' do
          password_change_request
          expect(response).to redirect_to profile_path
        end

        context 'and a bad current_password parameter' do
          let(:params) do
            {
              current_password: 'bad',
              password: password,
              password_confirmation: password
            }
          end

          it 'does not change the password' do
            expect { password_change_request }
              .not_to change { participant.identities.first.password_digest }
          end

          it 'does not redirect' do
            password_change_request
            expect(response).not_to be_redirect
          end
        end

        context 'and a missing current_password parameter' do
          let(:params) do
            {
              password: password,
              password_confirmation: password
            }
          end

          it 'does not change the password' do
            expect { password_change_request }
              .not_to change { participant.identities.first.password_digest }
          end

          it 'does not redirect' do
            password_change_request
            expect(response).not_to be_redirect
          end
        end
      end
    end
  end
end
