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

  describe '#each' do
    before do
      create_list(:pitch, 5, :for_workshop, :submitted, festival: festival)
    end

    it 'calls a block' do
      pitches = []
      query.each { |pitch| pitches << pitch }
      expect(pitches).to have_exactly(5).items
    end
  end
end
