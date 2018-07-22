# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PeopleController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/people' do
    context 'as HTML' do
      it 'returns http success' do
        get admin_people_path(festival)
        expect(response).to be_successful
      end
    end

    context 'as JSON' do
      let(:json) { JSON.parse(response.body).deep_symbolize_keys }

      it 'returns JSON' do
        get admin_people_path(festival, format: :json)
        expect(json).to match(
          self: hash_including(id: admin.to_param),
          people: [
            hash_including(id: admin.to_param)
          ]
        )
      end
    end
  end
end
