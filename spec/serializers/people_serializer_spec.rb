# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PeopleSerializer, type: :serializer do
  subject(:serializer) do
    PeopleSerializer.new(self: matt, people: Participant.all)
  end
  let(:json) { serializer.call }
  let!(:matt) do
    create(
      :admin,
      :with_avatar,
      name: 'Matt Powell',
      email: 'matt@nzimprovfestival.co.nz',
      city: 'Wellington',
      country: 'New Zealand'
    )
  end
  let!(:jim) do
    create(
      :participant,
      name: 'Jim Fishwick',
      email: 'jim@acmi.com.au',
      city: 'Melbourne',
      country: 'Australia'
    )
  end

  it 'produces the correct JSON' do
    # rubocop:disable Style/BracesAroundHashParameters
    expect(json).to match(
      self: hash_including(id: matt.to_param),
      people: a_collection_containing_exactly(
        {
          id: matt.to_param,
          name: matt.name,
          email: matt.email,
          admin: true,
          avatar: /.+/,
          city: 'Wellington',
          country: 'New Zealand'
        },
        {
          id: jim.to_param,
          name: jim.name,
          email: jim.email,
          admin: false,
          avatar: nil,
          city: 'Melbourne',
          country: 'Australia'
        }
      )
    )
    # rubocop:enable Style/BracesAroundHashParameters
  end
end
