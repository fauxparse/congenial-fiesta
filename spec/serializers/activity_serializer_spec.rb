# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ActivitySerializer, type: :serializer do
  subject(:serializer) { ActivitySerializer.new(activity) }
  let(:activity) { create(:workshop, name: 'a workshop', maximum: 15) }
  let!(:presenter) { create(:presenter, activity: activity) }
  let(:json) { serializer.call }

  it 'represents the activity' do
    expect(json).to eq(
      id: activity.id,
      name: 'a workshop',
      type: 'Workshop',
      maximum: 15,
      presenters: [{
        id: presenter.participant.id,
        name: presenter.participant.name
      }]
    )
  end
end
