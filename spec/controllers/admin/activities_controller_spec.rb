# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ActivitiesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'POST /admin/:year/activities' do
    def do_create
      post(
        admin_activities_path(festival, format: :json),
        params: { activity: attributes }
      )
    end

    context 'with valid attributes' do
      let(:attributes) { { name: 'A workshop', type: 'Workshop' } }

      it 'creates a workshop' do
        expect { do_create }.to change(Workshop, :count).by(1)
      end

      it 'is successful' do
        do_create
        expect(response).to be_successful
      end
    end

    context 'with invalid attributes' do
      let(:attributes) { { name: 'Generic activity' } }

      it 'does not create a workshop' do
        expect { do_create }.not_to change(Activity, :count)
      end

      it 'is not successful' do
        expect(response).not_to be_successful
      end
    end
  end
end
