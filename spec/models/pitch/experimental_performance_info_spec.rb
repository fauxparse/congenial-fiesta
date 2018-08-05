# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::ExperimentalPerformanceInfo do
  subject(:info) { Pitch::ExperimentalPerformanceInfo.new(data) }
  let(:data) do
    {
      name: 'Das Experiment',
      workshop_description: 'Workshop',
      show_description: 'Show',
      cast_size: '6',
      experience: 'None'
    }
  end

  it { is_expected.to be_valid }

  describe '#levels' do
    subject(:levels) { info.levels.to_a }
    it { is_expected.to eq %w[advanced] }
  end
end
