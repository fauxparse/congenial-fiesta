# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ActivitiesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }
  let(:json) { JSON.parse(response.body).deep_symbolize_keys }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/activities' do
    context 'as HTML' do
      before { get admin_activities_path(festival) }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'as JSON' do
      let!(:workshop) { create(:workshop, festival: festival) }
      before { get admin_activities_path(festival, format: :json) }

      it 'includes the workshop' do
        expect(json).to match(
          activities: [a_hash_including(id: workshop.id)],
          activity_types: a_collection_containing_exactly(
            { name: 'Workshop', label: 'Workshop' },
            { name: 'Show', label: 'Show' },
            { name: 'SocialEvent', label: 'Social Event' },
            { name: 'Forum', label: 'Forum' },
          )
        )
      end
    end
  end

  describe 'GET /admin/:year/workshops/:slug' do
    let!(:workshop) { create(:workshop, festival: festival) }

    context 'as HTML' do
      before { get admin_workshop_path(festival, workshop) }

      it 'is successful' do
        expect(response).to be_successful
      end
    end

    context 'as JSON' do
      before { get admin_workshop_path(festival, workshop, format: :json) }

      it 'returns correct JSON' do
        expect(json).to match a_hash_including(id: workshop.id)
      end
    end
  end

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

  describe 'PUT /admin/:year/workshops/:slug' do
    let!(:workshop) { create(:workshop, festival: festival) }

    def do_update(format: :html)
      put admin_workshop_path(festival, workshop, format: format),
        params: params
    end

    context 'as HTML' do
      context 'with good attributes' do
        let(:params) { { activity: { name: 'Updated' } } }

        it 'updates the activity' do
          expect { do_update }
            .to change { workshop.reload.name }
            .to 'Updated'
          expect(response)
            .to redirect_to admin_workshop_path(festival, workshop)
        end
      end

      context 'with bad attributes' do
        let(:params) { { activity: { name: '' } } }

        it 'does not update the activity' do
          expect { do_update }.not_to change { workshop.reload.name }
        end
      end
    end

    context 'as JSON' do
      context 'with good attributes' do
        let(:params) { { activity: { name: 'Updated' } } }

        it 'updates the activity' do
          do_update(format: :json)
          expect(json).to match a_hash_including(name: 'Updated')
        end
      end

      context 'with bad attributes' do
        let(:params) { { activity: { name: '' } } }

        it 'does not update the activity' do
          expect { do_update(format: :json) }
            .not_to change { workshop.reload.name }
        end
      end
    end
  end
end
