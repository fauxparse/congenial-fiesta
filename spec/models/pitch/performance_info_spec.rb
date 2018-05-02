# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::PerformanceInfo do
  subject(:info) { Pitch::PerformanceInfo.new(data) }
  let(:data) { { cast_size: '6' } }

  describe '#cast_size' do
    subject(:cast_size) { info.cast_size }
    it { is_expected.to be_an_instance_of Integer }
  end
end
