# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitches, type: :query do
  subject(:query) { Pitches.new(festival, parameters) }
  let(:festival) { create(:festival) }
  let(:parameters) { {} }

  describe '#statuses' do
    subject(:statuses) { query.statuses }
    it { is_expected.not_to include('draft') }
  end
end
