# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PersonSerializer, type: :serializer do
  subject(:serializer) { PersonSerializer.new(matt) }
  let(:json) { serializer.call }
  let(:matt) do
    create(
      :admin,
      :with_avatar,
      name: 'Matt Powell',
      email: 'matt@nzimprovfestival.co.nz',
      city: 'Wellington',
      country: 'New Zealand',
      country_code: 'NZ',
      bio: 'a egg'
    )
  end

  it 'produces the correct JSON' do
    expect(json).to match(
      id: matt.to_param,
      name: matt.name,
      email: matt.email,
      admin: true,
      avatar: /.+/,
      city: 'Wellington',
      country: 'New Zealand',
      country_code: 'NZ',
      bio: 'a egg'
    )
  end
end
