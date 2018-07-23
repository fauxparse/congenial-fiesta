# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationPolicy, type: :policy do
  subject(:policy) { ApplicationPolicy.new(participant, nil) }

  context 'for a normal user' do
    let(:participant) { create(:participant) }

    it { is_expected.not_to be_index }
    it { is_expected.not_to be_show }
    it { is_expected.not_to be_new }
    it { is_expected.not_to be_create }
    it { is_expected.not_to be_edit }
    it { is_expected.not_to be_update }
    it { is_expected.not_to be_destroy }
  end

  context 'for an admin user' do
    let(:participant) { create(:admin) }

    it { is_expected.to be_index }
    it { is_expected.to be_show }
    it { is_expected.to be_new }
    it { is_expected.to be_create }
    it { is_expected.to be_edit }
    it { is_expected.to be_update }
    it { is_expected.to be_destroy }
  end

  describe '::Scope' do
    subject(:scope) do
      ApplicationPolicy::Scope.new(participant, Festival).resolve
    end
    let!(:participant) { create(:participant) }
    let!(:festival) { create(:festival) }

    it { is_expected.to include(festival) }
  end
end
