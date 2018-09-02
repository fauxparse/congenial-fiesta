# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationPolicy, type: :policy do
  subject(:policy) { RegistrationPolicy.new(participant, registration) }
  let(:registration) { create(:registration) }

  context 'for a normal user' do
    let(:participant) { create(:participant) }

    context 'for their own registration' do
      let(:registration) { create(:registration, participant: participant) }

      it { is_expected.to be_update }
    end

    context 'for someone else’s registration' do
      it { is_expected.not_to be_update }
    end
  end

  context 'for an admin user' do
    let(:participant) { create(:admin) }
    it { is_expected.to be_update }
  end
end
