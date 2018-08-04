# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Workshop, type: :model do
  describe '.to_param' do
    subject { described_class.to_param }
    it { is_expected.to eq 'workshops' }
  end

  describe '.levels' do
    subject { Workshop.levels }
    it { is_expected.to eq %i[rookie intermediate advanced] }
  end
end
