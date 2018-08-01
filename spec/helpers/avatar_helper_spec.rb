# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AvatarHelper, type: :helper do
  subject(:html) { helper.avatar(participant) }

  context 'for a participant with no avatar' do
    let(:participant) { create(:participant) }

    it { is_expected.to include 'icon--user' }
  end

  context 'for a participant with an avatar' do
    let(:participant) { create(:participant, :with_avatar) }

    it do
      expect(participant.avatar).to be_attached
    end
    it { is_expected.not_to include 'icon--user' }
    it { is_expected.to include 'img' }
  end
end
