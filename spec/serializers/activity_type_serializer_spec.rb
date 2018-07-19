# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivityTypeSerializer, type: :serializer do
  subject(:serializer) { ActivityTypeSerializer.new(Workshop) }
  let(:json) { serializer.call }

  it 'represents the activity type' do
    expect(json).to eq(
      name: 'Workshop',
      label: 'Workshop'
    )
  end
end
