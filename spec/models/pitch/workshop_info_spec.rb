# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::WorkshopInfo do
  subject(:info) { Pitch::WorkshopInfo.new(data) }
  let(:data) { {} }

  describe '#levels' do
    subject(:levels) { info.levels }
    it { is_expected.to be_an_instance_of Set }

    context 'assignment' do
      before { info.levels = ['beginner', ''] }
      it { is_expected.to eq Set.new(['beginner']) }
    end
  end
end
