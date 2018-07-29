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

  describe 'PUT /admin/:year/people/:id' do
    let!(:participant) { create(:participant) }
    let(:params) { { person: { name: 'Updated', email: 'updated@gmail.com' } } }

    def do_update
      put admin_person_path(festival, participant, format: :json),
        params: params
    end

    it 'updates the participant' do
      expect { do_update }
        .to change { participant.reload.name }
        .to('Updated')
        .and change { participant.email }
        .to('updated@gmail.com')
    end
  end
end
