# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TicketsController, type: :request do
  let(:festival) { create(:festival) }
  let(:bats) do
    create(:participant, :with_password,  role_list: %w(box_office))
  end

  before { log_in_as(bats) }

  describe 'GET /admin/:year/tickets' do
    it 'is successful' do
      get admin_tickets_path(festival)
      expect(response).to be_successful
    end
  end

  describe 'GET /admin/:year/tickets/:id' do
    let(:show) { create(:show, festival: festival) }
    let!(:schedule) { create(:schedule, activity: show) }

    it 'is successful' do
      get admin_ticket_path(festival, show)
      expect(response).to be_successful
    end
  end
end
