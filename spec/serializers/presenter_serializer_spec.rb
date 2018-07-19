# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PresenterSerializer, type: :serializer do
  subject(:serializer) { PresenterSerializer.new(presenter) }
  let(:presenter) { create(:presenter) }
  let(:json) { serializer.call }

  it 'represents the presenter' do
    expect(json).to eq(
      id: presenter.participant.id,
      name: presenter.participant.name
    )
  end
end
