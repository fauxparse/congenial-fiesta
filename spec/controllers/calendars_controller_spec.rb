# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CalendarsController, type: :request do
  let(:festival) { create(:festival) }

  before do
    allow_any_instance_of(ApplicationController)
      .to receive(:festival)
      .and_return(festival)
  end

  describe 'GET /calendar' do
    it 'is successful' do
      get calendar_path
      expect(response).to be_successful
    end
  end
end
