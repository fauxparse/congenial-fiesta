# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::PitchesController, type: :request do
  let(:festival) { create(:festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/pitches' do
    it 'returns http success' do
      get admin_pitches_path(festival)
      expect(response).to be_successful
    end
  end
end
