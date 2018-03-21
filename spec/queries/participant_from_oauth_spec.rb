# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantFromOauth, type: :query do
  subject(:query) { ParticipantFromOauth.new(oauth_hash) }
  let(:uid) { SecureRandom.uuid }
  let(:email) { 'participant@email.com' }
  let(:provider) { :twitter }
  let(:oauth_hash) do
    {
      provider: provider.to_s,
      uid: uid,
      info: {
        name: 'participant',
        email: email
      }
    }
  end

  describe '#participant' do
    subject(:participant) { query.participant }

    describe 'for an existing participant' do
      let!(:existing) { create(:participant, :with_oauth) }
      let(:uid) { existing.identities.first.uid }

      it { is_expected.to eq existing }

      it 'does not create a participant' do
        expect { participant }.not_to change(Participant, :count)
      end
    end

    describe 'for an existing participant with a different login method' do
      let!(:existing) { create(:participant, :with_password) }
      let(:email) { existing.email }

      it { is_expected.to eq(existing) }

      it 'does not create a participant' do
        expect { participant }.not_to change(Participant, :count)
      end

      it 'creates an identity' do
        expect { participant }.to change(Identity::Oauth, :count).by(1)
      end
    end

    describe 'for a new participant' do
      it { is_expected.to be_persisted }

      it 'creates a participant' do
        expect { participant }.to change(Participant, :count).by(1)
      end
    end
  end
end
