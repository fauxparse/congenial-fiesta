# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FestivalsController, type: :request do
  before { create(:festival) }

  describe 'GET /' do
    it 'returns http success' do
      get root_path
      expect(response).to be_successful
    end
  end
end
