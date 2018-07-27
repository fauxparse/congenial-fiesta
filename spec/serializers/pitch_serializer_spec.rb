# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchSerializer, type: :serializer do
  subject(:serializer) { PitchSerializer.new(pitch) }
  let(:pitch) do
    create(
      :pitch,
      :for_workshop,
      gender_list: %w(women),
      origin_list: %w(nz),
      pile: 'maybe'
    )
  end
  let(:json) { serializer.call }

  it 'represents the activity' do
    expect(json).to eq(
      id: pitch.to_param,
      name: 'Workshop',
      gender: 'women',
      origin: 'nz',
      pile: 'maybe'
    )
  end
end
